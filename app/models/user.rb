class User < ApplicationRecord
  validates :name, presence: true

  # Authorization relationships
  has_many :document_viewers,
    -> { where(namespace: "document", relation: "viewer") },
    class_name: "AuthorizationTuple",
    as: :subject

  has_many :document_editors,
    -> { where(namespace: "document", relation: "editor") },
    class_name: "AuthorizationTuple",
    as: :subject

  has_many :document_owners,
    -> { where(namespace: "document", relation: "owner") },
    class_name: "AuthorizationTuple",
    as: :subject

  has_many :folder_viewers,
    -> { where(namespace: "folder", relation: "viewer") },
    class_name: "AuthorizationTuple",
    as: :subject

  has_many :folder_editors,
    -> { where(namespace: "folder", relation: "editor") },
    class_name: "AuthorizationTuple",
    as: :subject

  has_many :folder_owners,
    -> { where(namespace: "folder", relation: "owner") },
    class_name: "AuthorizationTuple",
    as: :subject

  has_many :folder_admins,
    -> { where(namespace: "folder", relation: "admin") },
    class_name: "AuthorizationTuple",
    as: :subject

  has_many :organization_members,
    -> { where(namespace: "organization", relation: "member") },
    class_name: "AuthorizationTuple",
    as: :subject

  has_many :organization_admins,
    -> { where(namespace: "organization", relation: "admin") },
    class_name: "AuthorizationTuple",
    as: :subject

  has_many :team_members,
    -> { where(namespace: "team", relation: "member") },
    class_name: "AuthorizationTuple",
    as: :subject

  has_many :team_admins,
    -> { where(namespace: "team", relation: "admin") },
    class_name: "AuthorizationTuple",
    as: :subject

  has_many :project_viewers,
    -> { where(namespace: "project", relation: "viewer") },
    class_name: "AuthorizationTuple",
    as: :subject

  has_many :project_contributors,
    -> { where(namespace: "project", relation: "contributor") },
    class_name: "AuthorizationTuple",
    as: :subject

  has_many :project_managers,
    -> { where(namespace: "project", relation: "manager") },
    class_name: "AuthorizationTuple",
    as: :subject

  # Helper methods for checking permissions
  def can?(permission, resource)
    Authorization.check(self, permission, resource)
  end
end
