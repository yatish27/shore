module Authorization
  # The Checker class handles the core permission evaluation logic
  class Checker
    attr_reader :namespace, :visited_tuples

    def initialize(namespace)
      @namespace = namespace
      @visited_tuples = Set.new
      @max_depth = 10  # Prevent infinite recursion with a reasonable depth limit
    end

    # Main entry point for checking permissions
    # Params:
    #   subject: The user or other entity requesting access
    #   permission_name: The permission to check (e.g., :view, :edit)
    #   resource: The resource being accessed
    # Returns: true if subject has permission, false otherwise
    def check(subject, permission_name, resource)
      start_time = Time.current
      permission = @namespace.permissions[permission_name.to_sym]
      return false unless permission

      Rails.logger.debug "Checking permission #{permission_name} for #{subject.class.name}:#{subject.id} on #{resource.class.name}:#{resource.id}"

      # Check cache first if enabled
      if Authorization.configuration.use_cache
        cache_result = AuthorizationCacheEntry.get_cached_result(
          resource.class.name.underscore,
          resource.id.to_s,
          permission_name.to_s,
          subject.class.name.underscore,
          subject.id.to_s
        )

        if cache_result
          Rails.logger.debug "Cache hit for permission check"
          return cache_result[:result]
        end
      end

      # Evaluate the permission
      result = permission.evaluate(self, subject, resource)

      # Cache the result if enabled
      if Authorization.configuration.use_cache
        AuthorizationCacheEntry.cache_result(
          resource.class.name.underscore,
          resource.id.to_s,
          permission_name.to_s,
          subject.class.name.underscore,
          subject.id.to_s,
          result
        )
      end

      check_time = (Time.current - start_time) * 1000.0 # in milliseconds
      Rails.logger.debug "Permission check result: #{result} (#{check_time.round(2)}ms)"

      result
    end

    # Check if a subject has a specific relation to a resource
    # This is used both directly and as part of evaluating permission expressions
    def check_relation(subject, relation_name, resource, depth = 0)
      return false if depth > @max_depth

      relation = @namespace.relations[relation_name.to_sym]
      return false unless relation

      namespace_str = resource.class.name.underscore
      resource_id = resource.id.to_s
      subject_type = subject.class.name.underscore
      subject_id = subject.id.to_s
      relation_str = relation_name.to_s

      # Create a unique key for this relation check to avoid cycles
      visit_key = "#{namespace_str}:#{resource_id}:#{relation_str}:#{subject_type}:#{subject_id}"
      return false if @visited_tuples.include?(visit_key)
      @visited_tuples.add(visit_key)

      Rails.logger.debug "  Checking relation #{relation_name} at depth #{depth}"

      # Check direct relation - e.g., user is directly a viewer of document
      direct_relation = AuthorizationTuple.find_direct_relation(
        namespace_str,
        resource_id,
        relation_str,
        subject_type,
        subject_id
      )

      if direct_relation
        Rails.logger.debug "  ✅ Found direct relation"

        # Check caveat if present
        if direct_relation.has_caveat?
          unless AuthorizationCaveat.evaluate_caveat(
            direct_relation.caveat_name,
            direct_relation.caveat_context
          )
            Rails.logger.debug "  ❌ Caveat check failed"
            return false
          end
        end

        return true
      end

      # Check wildcard relations - e.g., "all users can view public documents"
      wildcard_relations = AuthorizationTuple.find_wildcard_relations(
        namespace_str,
        resource_id,
        relation_str,
        subject_type
      )

      if wildcard_relations.any?
        # Check if any wildcard relation applies (with caveats if present)
        wildcard_relations.each do |wildcard|
          if !wildcard.has_caveat? || AuthorizationCaveat.evaluate_caveat(
            wildcard.caveat_name,
            wildcard.caveat_context
          )
            Rails.logger.debug "  ✅ Found wildcard relation"
            return true
          end
        end
      end

      # Check computed relations - e.g., user is a member of a team that has viewer access
      computed_tuples = AuthorizationTuple.find_computed_relations(
        namespace_str,
        resource_id,
        relation_str
      )

      computed_tuples.each do |tuple|
        Rails.logger.debug "  📝 Checking computed relation via #{tuple.subject_type}:#{tuple.subject_id}##{tuple.subject_relation}"

        # Get the intermediate object (e.g., the team)
        begin
          intermediate_class = tuple.subject_type.classify.constantize
          intermediate_object = intermediate_class.find_by(id: tuple.subject_id)

          unless intermediate_object
            Rails.logger.warn "Intermediate object #{tuple.subject_type}:#{tuple.subject_id} not found"
            next
          end

          # Get the namespace for the intermediate object type
          intermediate_namespace = Schema.namespaces[tuple.subject_type.to_sym]
          unless intermediate_namespace
            Rails.logger.warn "Namespace for #{tuple.subject_type} not defined in schema"
            next
          end

          # Create a checker for the intermediate object's namespace
          intermediate_checker = Checker.new(intermediate_namespace)
          # Share the visited set to avoid cycles
          intermediate_checker.visited_tuples.merge(@visited_tuples)

          # Check if subject has the required relation to the intermediate object
          if intermediate_checker.check_relation(
              subject,
              tuple.subject_relation.to_sym,
              intermediate_object,
              depth + 1
            )
            Rails.logger.debug "  ✅ Found computed relation via #{tuple.subject_type}:#{tuple.subject_id}##{tuple.subject_relation}"

            # Check caveat if present
            if tuple.has_caveat?
              unless AuthorizationCaveat.evaluate_caveat(
                tuple.caveat_name,
                tuple.caveat_context
              )
                Rails.logger.debug "  ❌ Caveat check failed"
                next
              end
            end

            return true
          end
        rescue => e
          Rails.logger.error "Error checking computed relation: #{e.message}"
          Rails.logger.debug e.backtrace.join("\n")
        end
      end

      # Check relation alternatives from the pipe operator expressions
      if relation.expression_alternatives.any?
        Rails.logger.debug "  📝 Checking relation alternatives from pipe expressions"

        relation.expression_alternatives.each do |alternative|
          if alternative[:type] == :direct
            # Direct subject type check
            if subject_type == alternative[:subject_type]
              Rails.logger.debug "  ✅ Subject type matches direct alternative: #{alternative[:subject_type]}"
              return true
            end
          elsif alternative[:type] == :computed
            # Computed relation via another namespace
            namespace_name = alternative[:namespace]
            relation_name = alternative[:relation]

            # Check if the referenced namespace exists
            referenced_namespace = Schema.namespaces[namespace_name.to_sym]
            unless referenced_namespace
              Rails.logger.warn "Referenced namespace #{namespace_name} not defined in schema"
              next
            end

            # Create a checker for the referenced namespace
            referenced_checker = Checker.new(referenced_namespace)
            referenced_checker.visited_tuples.merge(@visited_tuples)

            # Find objects of the referenced namespace type that are related to this resource
            related_tuples = AuthorizationTuple.where(
              namespace: namespace_str,
              object_id: resource_id,
              relation: namespace_name
            )

            # Check if subject has the specified relation to any of those objects
            if related_tuples.any? do |tuple|
                referenced_class = tuple.subject_type.classify.constantize
                referenced_object = referenced_class.find_by(id: tuple.subject_id)

                if referenced_object && referenced_checker.check_relation(
                    subject,
                    relation_name.to_sym,
                    referenced_object,
                    depth + 1
                  )
                  Rails.logger.debug "  ✅ Found relation via #{namespace_name}##{relation_name}"
                  true
                else
                  false
                end
              end
              return true
            end
          end
        end
      end

      Rails.logger.debug "  ❌ No relation found"
      false
    end

    # Evaluate a union expression (a + b)
    def evaluate_union(subject, resource, expressions, depth = 0)
      return false if depth > @max_depth

      expressions.any? do |expr|
        evaluate_expression(subject, resource, expr, depth + 1)
      end
    end

    # Evaluate an intersection expression (a & b)
    def evaluate_intersection(subject, resource, expressions, depth = 0)
      return false if depth > @max_depth

      expressions.all? do |expr|
        evaluate_expression(subject, resource, expr, depth + 1)
      end
    end

    # Evaluate a single expression which could be a relation or another permission
    def evaluate_expression(subject, resource, expression, depth = 0)
      return false if depth > @max_depth

      case expression
      when Symbol, String
        # Check if this is a relation or a permission
        relation_name = expression.to_sym

        if @namespace.relations.key?(relation_name)
          # It's a relation
          check_relation(subject, relation_name, resource, depth + 1)
        elsif @namespace.permissions.key?(relation_name)
          # It's another permission
          permission = @namespace.permissions[relation_name]
          permission.evaluate(self, subject, resource)
        else
          # If it contains a '#', it's a reference to another namespace's relation
          # E.g., "organization#admin"
          if expression.to_s.include?("#")
            namespace_name, relation_name = expression.to_s.split("#", 2)

            # Find relation tuples that match
            tuples = AuthorizationTuple.where(
              namespace: resource.class.name.underscore,
              object_id: resource.id.to_s,
              relation: namespace_name
            )

            tuples.any? do |tuple|
              referenced_class = tuple.subject_type.classify.constantize
              referenced_object = referenced_class.find_by(id: tuple.subject_id)

              if referenced_object
                referenced_namespace = Schema.namespaces[tuple.subject_type.to_sym]
                if referenced_namespace
                  referenced_checker = Checker.new(referenced_namespace)
                  referenced_checker.visited_tuples.merge(@visited_tuples)
                  referenced_checker.check_relation(subject, relation_name.to_sym, referenced_object, depth + 1)
                end
              end
            end
          else
            Rails.logger.warn "Unknown relation or permission: #{expression}"
            false
          end
        end
      when Proc
        # It's a custom block
        instance_exec(subject, resource, &expression)
      when Hash
        # It's a structured expression
        if expression[:union]
          # Union of expressions
          expression[:union].any? { |expr| evaluate_expression(subject, resource, expr, depth + 1) }
        elsif expression[:intersection]
          # Intersection of expressions
          expression[:intersection].all? { |expr| evaluate_expression(subject, resource, expr, depth + 1) }
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
                intermediate_checker.visited_tuples.merge(@visited_tuples)
                intermediate_checker.check_relation(subject, target_relation, intermediate_object, depth + 1)
              end
            end
          end
        else
          Rails.logger.warn "Unsupported expression type: #{expression.inspect}"
          false
        end
      else
        Rails.logger.warn "Unsupported expression type: #{expression.class}"
        false
      end
    end
  end
end
