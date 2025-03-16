class AuthorizationCacheEntry < ApplicationRecord
  validates :namespace, presence: true
  validates :object_id, presence: true
  validates :relation, presence: true
  validates :subject_type, presence: true
  validates :subject_id, presence: true
  validates :expires_at, presence: true

  scope :valid, -> { where("expires_at > ?", Time.current) }

  class << self
    # Get a cached result if available
    def get_cached_result(namespace, object_id, relation, subject_type, subject_id, subject_relation = nil)
      entry = valid.find_by(
        namespace: namespace,
        object_id: object_id,
        relation: relation,
        subject_type: subject_type,
        subject_id: subject_id,
        subject_relation: subject_relation
      )

      return nil unless entry

      {
        result: entry.result,
        caveat_expression: entry.caveat_expression
      }
    end

    # Cache a result
    def cache_result(namespace, object_id, relation, subject_type, subject_id, result, options = {})
      # Default TTL = 1 hour
      ttl = options[:ttl] || 1.hour
      expires_at = Time.current + ttl

      # Delete any existing entry
      where(
        namespace: namespace,
        object_id: object_id,
        relation: relation,
        subject_type: subject_type,
        subject_id: subject_id,
        subject_relation: options[:subject_relation]
      ).delete_all

      create!(
        namespace: namespace,
        object_id: object_id,
        relation: relation,
        subject_type: subject_type,
        subject_id: subject_id,
        subject_relation: options[:subject_relation],
        result: result,
        caveat_expression: options[:caveat_expression],
        expires_at: expires_at
      )
    end

    # Clear all expired entries
    def clear_expired
      where("expires_at <= ?", Time.current).delete_all
    end
  end
end
