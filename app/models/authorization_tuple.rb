class AuthorizationTuple < ApplicationRecord
  # Validations
  validates :namespace, presence: true
  validates :object_id, presence: true
  validates :relation, presence: true
  validates :subject_type, presence: true
  validates :subject_id, presence: true

  # Scopes for querying
  scope :by_resource, ->(namespace, object_id, relation) {
    where(namespace: namespace, object_id: object_id, relation: relation)
  }

  scope :by_subject, ->(subject_type, subject_id) {
    where(subject_type: subject_type, subject_id: subject_id)
  }

  scope :with_caveat, -> { where.not(caveat_name: nil) }
  scope :without_caveat, -> { where(caveat_name: nil) }

  scope :not_expired, -> {
    where("expires_at IS NULL OR expires_at > ?", Time.current)
  }

  # Class methods for easier relation management
  class << self
    # Create a direct relationship
    def create_relation(namespace, object_id, relation, subject_type, subject_id, options = {})
      create!({
        namespace: namespace.to_s,
        object_id: object_id.to_s,
        relation: relation.to_s,
        subject_type: subject_type.to_s,
        subject_id: subject_id.to_s,
        subject_relation: options[:subject_relation],
        caveat_name: options[:caveat_name],
        caveat_context: options[:caveat_context] || {},
        expires_at: options[:expires_at]
      })
    end

    # Find all relations that match a resource and relation
    def find_for_resource(namespace, object_id, relation)
      by_resource(namespace, object_id, relation)
        .not_expired
        .to_a
    end

    # Find direct relations between resource and specific subject
    def find_direct_relation(namespace, object_id, relation, subject_type, subject_id)
      by_resource(namespace, object_id, relation)
        .by_subject(subject_type, subject_id)
        .where(subject_relation: nil)
        .not_expired
        .first
    end

    # Find wildcard relations
    def find_wildcard_relations(namespace, object_id, relation, subject_type)
      by_resource(namespace, object_id, relation)
        .where(subject_type: subject_type, subject_id: "*")
        .not_expired
        .to_a
    end

    # Find computed relations (with subject_relation)
    def find_computed_relations(namespace, object_id, relation)
      by_resource(namespace, object_id, relation)
        .where.not(subject_relation: nil)
        .not_expired
        .to_a
    end
  end

  # Helper methods
  def computed_relation?
    subject_relation.present?
  end

  def direct_relation?
    !computed_relation?
  end

  def has_caveat?
    caveat_name.present?
  end

  def expired?
    expires_at.present? && expires_at <= Time.current
  end
end
