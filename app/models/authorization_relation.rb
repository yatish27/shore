class AuthorizationRelation < ApplicationRecord
  belongs_to :namespace,
    class_name: "AuthorizationNamespace",
    foreign_key: "authorization_namespace_id"

  validates :name, presence: true
  validates :type_name, presence: true, inclusion: { in: [ "relation", "permission" ] }
  validates :definition, presence: true
  validates :name, uniqueness: { scope: :authorization_namespace_id }

  # Type checking methods
  def permission?
    type_name == "permission"
  end

  def relation?
    type_name == "relation"
  end

  # Get the parsed definition
  def parsed_definition
    @parsed_definition ||= definition
  end

  # Get userset rewrite if this is a permission
  def userset_rewrite
    permission? ? parsed_definition["userset_rewrite"] : nil
  end

  # Get allowed direct relations if this is a relation
  def allowed_direct_relations
    relation? ? parsed_definition["allowed_direct_relations"] : nil
  end
end
