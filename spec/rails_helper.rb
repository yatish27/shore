ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"
abort("The Rails environment is running in production mode!") if Rails.env.production?

Rails.root.glob("spec/support/**/*.rb").each { |f| require f }
require "rspec/rails"

require "dotenv"
Dotenv.load(".env.test")

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [Rails.root.join("spec/fixtures")]
  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!
  config.order = "random"

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
