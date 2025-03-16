Authorization.configure do |config|
  # Enable caching for permission checks
  # Using caching can significantly improve performance but may cause
  # permissions to be outdated until the cache expires
  config.use_cache = Rails.env.production?

  # Cache TTL (time-to-live) for cached permission results
  config.cache_ttl = 30.minutes

  # Maximum recursion depth for permission checks
  config.default_depth_limit = 10
end

# Load the authorization schema
Rails.application.config.after_initialize do
  puts "Loading authorization schema from initializer..."
  require Rails.root.join("config/authorization_schema")
  puts "Authorization schema loaded with namespaces: #{Authorization::Schema.namespaces.keys.inspect}"
end
