namespace :authorization do
  desc "Load schema definitions into the database"
  task load_schema: :environment do
    Authorization::SchemaLoader.load_schema
    Authorization::SchemaLoader.sync_to_database
    puts "Schema definitions loaded and synced to database."
  end

  desc "Clear expired relations"
  task clear_expired: :environment do
    time_now = Time.current
    count = AuthorizationTuple.where("expires_at IS NOT NULL AND expires_at <= ?", time_now).delete_all
    puts "Cleared #{count} expired relation tuples."
  end

  desc "Clear expired cache entries"
  task clear_expired_cache: :environment do
    time_now = Time.current
    count = AuthorizationCacheEntry.where("expires_at <= ?", time_now).delete_all
    puts "Cleared #{count} expired cache entries."
  end

  desc "List all namespaces and their relations"
  task list_schema: :environment do
    puts "=== Authorization Schema ==="
    AuthorizationNamespace.all.each do |namespace|
      puts "\nNamespace: #{namespace.name}"

      puts "  Relations:"
      namespace.direct_relations.each do |relation|
        puts "    - #{relation.name}"
      end

      puts "  Permissions:"
      namespace.permissions.each do |permission|
        puts "    - #{permission.name}: #{permission.parsed_definition["userset_rewrite"].inspect}"
      end
    end
  end
end
