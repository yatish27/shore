module Authorization
  # Schema class for defining authorization schema
  class Schema
    class << self
      attr_reader :namespaces

      def definition(namespace_name, &block)
        namespace = Namespace.new(namespace_name)
        namespace.instance_eval(&block) if block_given?

        @namespaces ||= {}
        @namespaces[namespace_name.to_sym] = namespace

        # Create convenience methods
        define_singleton_method(namespace_name) do
          @namespaces[namespace_name.to_sym]
        end
      end

      # Check a permission
      def check_permission(subject, permission_name, resource)
        namespace_name = resource.class.name.underscore.to_sym
        namespace = @namespaces[namespace_name]

        return false unless namespace

        checker = Checker.new(namespace)
        checker.check(subject, permission_name, resource)
      end
    end
  end

  # ExpressionParser class for parsing relation and permission expressions
  class ExpressionParser
    # Parse a relation definition expression (e.g., "user | usergroup#member")
    def self.parse_relation_expression(expression)
      return [] unless expression

      # Split by pipe operator to get alternative subject types
      alternatives = expression.to_s.split("|").map(&:strip)

      # Process each alternative
      alternatives.map do |alt|
        if alt.include?("#")
          # It's a reference to another namespace's relation
          namespace, relation = alt.split("#", 2)
          { type: :computed, namespace: namespace.strip, relation: relation.strip }
        else
          # It's a direct subject type
          { type: :direct, subject_type: alt.strip }
        end
      end
    end

    # Parse a permission expression (e.g., "viewer + manager" or "group->member")
    def self.parse_permission_expression(expression)
      return nil unless expression

      if expression.is_a?(Symbol) || (expression.is_a?(String) && !expression.include?("+") && !expression.include?("->"))
        # Simple relation reference
        return expression.to_sym
      elsif expression.is_a?(String)
        if expression.include?("->")
          # It's a computed relation via arrow operator
          source, target = expression.split("->", 2)
          return { computed_via: source.strip.to_sym, relation: target.strip.to_sym }
        elsif expression.include?("+")
          # It's a union expression
          parts = expression.split("+").map(&:strip)
          return { union: parts.map { |p| parse_permission_expression(p) } }
        elsif expression.include?("&")
          # It's an intersection expression
          parts = expression.split("&").map(&:strip)
          return { intersection: parts.map { |p| parse_permission_expression(p) } }
        end
      end

      # Default case
      expression
    end
  end

  # Namespace class represents an object type definition
  class Namespace
    attr_reader :name, :relations, :permissions

    def initialize(name)
      @name = name.to_sym
      @relations = {}
      @permissions = {}
    end

    # Handle method_missing to support assignment syntax for permissions
    def method_missing(method_name, *args, &block)
      if method_name.to_s == "relation" && args.length >= 1
        # Handle relation definition with type annotation
        relation_name = args[0]
        if args[1].is_a?(Hash) && args[1].key?(:type)
          # Original format: relation :name, type: :type
          relation(relation_name, args[1])
        elsif args.length >= 2 && args[1].is_a?(String)
          # New format: relation name: expression
          expression = args[1]
          @relations[relation_name.to_sym] = Relation.new(relation_name, { expression: expression })
        else
          super
        end
      elsif args.length == 1 && !block_given?
        # Handle permission assignment (e.g., permission manage = manager)
        if method_name.to_s == "permission"
          permission_name = args[0]
          @permissions[permission_name.to_sym] = Permission.new(permission_name, nil)
        else
          # This could be a permission assignment (e.g., manage = manager)
          permission = @permissions[method_name.to_sym]
          if permission
            permission.expression = ExpressionParser.parse_permission_expression(args[0])
          else
            super
          end
        end
      else
        super
      end
    end

    def relation(name, options = {})
      if options[:expression]
        # New format with expression
        @relations[name.to_sym] = Relation.new(name, options)
      else
        # Original format
        @relations[name.to_sym] = Relation.new(name, options)
      end
    end

    def permission(name, expression = nil, &block)
      if block_given?
        @permissions[name.to_sym] = Permission.new(name, nil, &block)
      else
        parsed_expression = expression.nil? ? nil : ExpressionParser.parse_permission_expression(expression)
        @permissions[name.to_sym] = Permission.new(name, parsed_expression)
      end
    end
  end

  # Relation class represents a relationship definition
  class Relation
    attr_reader :name, :target_type, :expression_alternatives

    def initialize(name, options = {})
      @name = name.to_sym
      @target_type = options[:type]

      if options[:expression]
        @expression_alternatives = ExpressionParser.parse_relation_expression(options[:expression])
      else
        @expression_alternatives = []
      end
    end
  end

  # Permission class represents a permission definition
  class Permission
    attr_reader :name, :block
    attr_accessor :expression

    def initialize(name, expression = nil, &block)
      @name = name.to_sym
      @expression = expression
      @block = block
    end

    def evaluate(checker, subject, resource)
      if @block
        checker.instance_exec(subject, resource, &@block)
      elsif @expression
        evaluate_expression(checker, subject, resource, @expression)
      else
        false
      end
    end

    private

    def evaluate_expression(checker, subject, resource, expression)
      case expression
      when Symbol
        # It's a direct relation
        checker.check_relation(subject, expression, resource)
      when String
        # Parse the expression (simplified for now)
        parts = expression.split(" + ")

        parts.any? do |part|
          if part.include?(" & ")
            subparts = part.split(" & ")
            subparts.all? { |sp| evaluate_expression(checker, subject, resource, sp.strip.to_sym) }
          else
            evaluate_expression(checker, subject, resource, part.strip.to_sym)
          end
        end
      when Hash
        if expression[:union]
          # Union of expressions
          expression[:union].any? { |expr| evaluate_expression(checker, subject, resource, expr) }
        elsif expression[:intersection]
          # Intersection of expressions
          expression[:intersection].all? { |expr| evaluate_expression(checker, subject, resource, expr) }
        elsif expression[:computed_via]
          # Computed via another relation (arrow operator)
          source_relation = expression[:computed_via]
          target_relation = expression[:relation]

          # Find all objects related to the resource via source_relation
          tuples = AuthorizationTuple.where(
            namespace: resource.class.name.underscore,
            object_id: resource.id.to_s,
            relation: source_relation.to_s
          )

          # Check if subject has target_relation to any of those objects
          tuples.any? do |tuple|
            intermediate_class = tuple.subject_type.classify.constantize
            intermediate_object = intermediate_class.find_by(id: tuple.subject_id)

            if intermediate_object
              intermediate_namespace = Schema.namespaces[tuple.subject_type.to_sym]
              if intermediate_namespace
                intermediate_checker = Checker.new(intermediate_namespace)
                intermediate_checker.visited_tuples.merge(checker.visited_tuples)
                intermediate_checker.check_relation(subject, target_relation, intermediate_object)
              end
            end
          end
        else
          false
        end
      when Array
        # Union of expressions
        expression.any? { |expr| evaluate_expression(checker, subject, resource, expr) }
      else
        false
      end
    end
  end

  # MembershipSet is used to track found permissions during checking
  class MembershipSet
    def initialize
      @members = {}
    end

    def add_direct_member(resource_id, caveat = nil)
      @members[resource_id] = { direct: true, caveat: caveat }
    end

    def add_member_with_parent_caveat(resource_id, expression, parent_caveat)
      @members[resource_id] = {
        direct: false,
        expression: expression,
        parent_caveat: parent_caveat
      }
    end

    def add_member_with_optional_caveats(resource_id, caveats = [])
      if caveats.empty?
        @members[resource_id] = { direct: true }
      else
        @members[resource_id] = {
          direct: false,
          caveats: caveats
        }
      end
    end

    def union_with(results_map)
      if results_map.is_a?(Hash)
        results_map.each do |resource_id, result|
          @members[resource_id] = { direct: false, expression: result["expression"] }
        end
      end
    end

    def intersect_with(results_map)
      # Keep only resource_ids that exist in both
      @members.select! do |resource_id, _|
        results_map.key?(resource_id)
      end

      # Update with combined caveats
      @members.each do |resource_id, data|
        if results_map[resource_id] && results_map[resource_id]["expression"]
          if data[:expression]
            # Combine expressions
            data[:expression] = { and: [ data[:expression], results_map[resource_id]["expression"] ] }
          else
            data[:expression] = results_map[resource_id]["expression"]
          end
        end
      end
    end

    def subtract(results_map)
      # Remove any resource_id that exists in results_map
      @members.reject! { |resource_id, _| results_map.key?(resource_id) }
    end

    def get_resource_id(resource_id)
      if @members.key?(resource_id)
        [ true, @members[resource_id][:caveat] ]
      else
        [ false, nil ]
      end
    end

    def has_concrete_resource_id?(resource_id)
      @members.key?(resource_id)
    end

    def size
      @members.size
    end

    def is_empty?
      @members.empty?
    end

    def has_determined_member?
      !is_empty?
    end

    def as_check_results_map
      results = {}

      @members.each do |resource_id, data|
        caveat_expression = nil

        if data[:caveat]
          caveat_expression = data[:caveat]
        elsif data[:expression]
          caveat_expression = data[:expression]
        elsif data[:caveats] && !data[:caveats].empty?
          # Combine caveats with AND
          if data[:caveats].size == 1
            caveat_expression = data[:caveats].first
          else
            caveat_expression = { and: data[:caveats] }
          end
        end

        results[resource_id] = {
          "membership" => true,
          "expression" => caveat_expression
        }
      end

      results
    end
  end
end
