module Authorization
  class SchemaLoader
    class << self
      def load_schema_file(file_path)
        require file_path
      end

      def load_schema
        if File.exist?(Rails.root.join("config/authorization_schema.rb"))
          load_schema_file(Rails.root.join("config/authorization_schema.rb"))
        end
      end

      # Sync in-memory schema to database
      def sync_to_database
        return unless tables_exist?

        # Get existing namespace names
        existing_namespaces = AuthorizationNamespace.pluck(:name)

        # Process each namespace
        Schema.namespaces.each do |name, namespace_obj|
          # Skip if namespace already exists
          next if existing_namespaces.include?(name.to_s)

          # Create namespace
          db_namespace = AuthorizationNamespace.new(name: name.to_s)

          namespace_definition = {
            relations: namespace_obj.relations.keys.map(&:to_s),
            permissions: namespace_obj.permissions.keys.map(&:to_s)
          }

          db_namespace.definition = namespace_definition
          db_namespace.save!

          # Process relations
          namespace_obj.relations.each do |relation_name, relation_obj|
            db_relation = db_namespace.relations.new(
              name: relation_name.to_s,
              type_name: "relation"
            )

            relation_definition = {
              target_type: relation_obj.target_type.to_s,
              allowed_direct_relations: []
            }

            # Add expression alternatives if present
            if relation_obj.expression_alternatives.any?
              relation_definition[:expression_alternatives] = relation_obj.expression_alternatives
            end

            db_relation.definition = relation_definition
            db_relation.save!
          end

          # Process permissions
          namespace_obj.permissions.each do |permission_name, permission_obj|
            db_permission = db_namespace.relations.new(
              name: permission_name.to_s,
              type_name: "permission"
            )

            # Convert expression to storable format
            if permission_obj.expression.is_a?(String)
              userset_rewrite = {
                type: "expression",
                expression: permission_obj.expression
              }
            elsif permission_obj.expression.is_a?(Symbol)
              userset_rewrite = {
                type: "relation",
                relation: permission_obj.expression.to_s
              }
            elsif permission_obj.expression.is_a?(Hash)
              # Handle structured expressions
              userset_rewrite = {
                type: "structured_expression",
                expression: permission_obj.expression
              }
            elsif permission_obj.block
              userset_rewrite = {
                type: "custom_block",
                block_id: permission_obj.object_id.to_s
              }
            end

            permission_definition = {
              userset_rewrite: userset_rewrite
            }

            db_permission.definition = permission_definition
            db_permission.save!
          end
        end
      end

      private

      def tables_exist?
        ActiveRecord::Base.connection.table_exists?("authorization_namespaces") &&
        ActiveRecord::Base.connection.table_exists?("authorization_relations")
      rescue
        false
      end
    end
  end
end
