require "set"

# Main authorization module
module Authorization
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    # Main entry point for checking permissions
    def check(subject, permission, resource)
      Schema.check_permission(subject, permission, resource)
    end

    # Create a relationship tuple
    def add_relation(resource, relation, subject, options = {})
      AuthorizationTuple.create_relation(
        resource.class.name.underscore,
        resource.id.to_s,
        relation.to_s,
        subject.class.name.underscore,
        subject.id.to_s,
        options
      )
    end

    # Remove a relationship tuple
    def remove_relation(resource, relation, subject)
      AuthorizationTuple.where(
        namespace: resource.class.name.underscore,
        object_id: resource.id.to_s,
        relation: relation.to_s,
        subject_type: subject.class.name.underscore,
        subject_id: subject.id.to_s
      ).delete_all
    end

    # Check if a relation exists
    def relation_exists?(resource, relation, subject)
      AuthorizationTuple.exists?(
        namespace: resource.class.name.underscore,
        object_id: resource.id.to_s,
        relation: relation.to_s,
        subject_type: subject.class.name.underscore,
        subject_id: subject.id.to_s
      )
    end
  end

  # Configuration class for authorization settings
  class Configuration
    attr_accessor :use_cache, :cache_ttl, :default_depth_limit

    def initialize
      @use_cache = false
      @cache_ttl = 1.hour
      @default_depth_limit = 10
    end
  end

  # Controller concern for easy integration with Rails controllers
  module Controller
    extend ActiveSupport::Concern

    included do
      rescue_from Authorization::NotAuthorizedError, with: :authorization_error

      def authorize!(permission, resource)
        unless Authorization.check(current_user, permission, resource)
          raise NotAuthorizedError.new("Not authorized to #{permission} this #{resource.class.name}")
        end
      end

      private

      def authorization_error(exception)
        respond_to do |format|
          format.html {
            flash[:error] = exception.message
            redirect_back(fallback_location: root_path)
          }
          format.json { render json: { error: exception.message }, status: :forbidden }
          format.any { head :forbidden }
        end
      end
    end
  end

  class NotAuthorizedError < StandardError; end
end

# Load all authorization components
require "authorization/schema"
require "authorization/schema_loader"
require "authorization/checker"
