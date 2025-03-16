# config/test_schema.rb
puts "Loading test authorization schema with new syntax..."

# Define the User namespace (empty - just a type)
Authorization::Schema.definition :user do
  # No relations or permissions needed
end

# Define Resource namespace with relations and permissions
Authorization::Schema.definition :resource do
  # Define relations with pipe operator syntax
  relation :manager, "user | usergroup#member | usergroup#manager"
  relation :viewer, "user | usergroup#member | usergroup#manager"

  # Define permissions with assignment syntax
  permission :manage
  manage = :manager

  permission :view
  view = "viewer + manager"
end

# Define UserGroup namespace
Authorization::Schema.definition :usergroup do
  # Define relations with pipe operator syntax
  relation :manager, "user | usergroup#member | usergroup#manager"
  relation :direct_member, "user | usergroup#member | usergroup#manager"

  # Define permissions with assignment syntax
  permission :member
  member = "direct_member + manager"
end

# Define Organization namespace
Authorization::Schema.definition :organization do
  # Define relations
  relation :group, "usergroup"
  relation :administrator, "user | usergroup#member | usergroup#manager"
  relation :direct_member, "user"
  relation :resource, "resource"

  # Define permissions with assignment syntax and arrow operator
  permission :admin
  admin = :administrator

  permission :member
  member = "direct_member + administrator + group->member"
end

puts "Test schema namespaces: #{Authorization::Schema.namespaces.keys.inspect}"

# Load the schema
Authorization::SchemaLoader.load_schema

puts "Test schema loaded successfully!"
