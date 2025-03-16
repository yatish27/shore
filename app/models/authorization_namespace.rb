class AuthorizationNamespace < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :definition, presence: true

  has_many :relations,
    class_name: "AuthorizationRelation",
    foreign_key: "authorization_namespace_id",
    dependent: :destroy

  # Find a relation by name
  def find_relation(name)
    relations.find_by(name: name)
  end

  # Get all permissions defined in this namespace
  def permissions
    relations.where(type_name: "permission")
  end

  # Get all direct relations defined in this namespace
  def direct_relations
    relations.where(type_name: "relation")
  end
end
