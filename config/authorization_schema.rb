# config/authorization_schema.rb
puts "Loading authorization schema..."

# Define the User namespace (empty - just a type)
Authorization::Schema.definition :user do
  # No relations or permissions needed
end

# Define Document namespace with relations and permissions
Authorization::Schema.definition :document do
  # Define relations (who can be related to documents)
  relation :viewer, type: :user
  relation :editor, type: :user
  relation :owner, type: :user
  relation :team, type: :team
  relation :parent_folder, type: :folder

  # Define permissions as combinations of relations
  permission :view, "viewer + editor + owner + team#member + parent_folder#view"
  permission :edit, "editor + owner + team#admin + parent_folder#edit"
  permission :delete, "owner + parent_folder#admin"

  # Custom permission with time-based logic
  permission :comment do |subject, resource|
    check_relation(subject, :viewer, resource) &&
      resource.comments_enabled? &&
      !resource.archived?
  end
end

# Define Folder namespace
Authorization::Schema.definition :folder do
  # Define relations
  relation :viewer, type: :user
  relation :editor, type: :user
  relation :owner, type: :user
  relation :admin, type: :user
  relation :parent, type: :folder

  # Define permissions with hierarchical inheritance
  permission :view, "viewer + editor + owner + admin + parent#view"
  permission :edit, "editor + owner + admin + parent#edit"
  permission :admin, "admin + owner"
  permission :create_document, "editor + owner + admin"
end

# Define Organization namespace
Authorization::Schema.definition :organization do
  # Define relations
  relation :member, type: :user
  relation :admin, type: :user

  # Define permissions
  permission :view, "member + admin"
  permission :manage, "admin"

  # Custom permission with a condition
  permission :join do |subject, resource|
    resource.public? || check_relation(subject, :admin, resource)
  end
end

# Define Team namespace
Authorization::Schema.definition :team do
  # Define relations
  relation :member, type: :user
  relation :admin, type: :user
  relation :organization, type: :organization

  # Define permissions (including computed from organization)
  permission :view, "member + admin + organization#admin"
  permission :manage, "admin + organization#admin"

  # Relation to members with a specific role
  permission :assign_tasks do |subject, resource|
    check_relation(subject, :member, resource) &&
      resource.members_can_assign_tasks? ||
      check_relation(subject, :admin, resource)
  end
end

# Define Project namespace with computed permissions
Authorization::Schema.definition :project do
  # Define relations
  relation :viewer, type: :user
  relation :contributor, type: :user
  relation :manager, type: :user
  relation :team, type: :team

  # Define permissions
  permission :view, "viewer + contributor + manager + team#member"
  permission :contribute, "contributor + manager + team#member"
  permission :manage, "manager + team#admin"

  # Complex permission with budget constraints
  permission :approve_expenses do |subject, resource|
    (check_relation(subject, :manager, resource) && resource.budget < 10000) ||
    (check_relation(subject, :team, resource) &&
      check_relation(subject, :admin, resource.team) && resource.budget < 5000)
  end
end

# Print debug info
puts "Schema namespaces: #{Authorization::Schema.namespaces.keys.inspect}"

# Load the schema
Authorization::SchemaLoader.load_schema

puts "Schema loaded successfully!"
