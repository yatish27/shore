require_relative "lib/granity/version"

Gem::Specification.new do |spec|
  spec.name        = "granity"
  spec.version     = Granity::VERSION
  spec.authors     = [ "Shore Team" ]
  spec.email       = [ "info@shore.com" ]
  spec.homepage    = "https://github.com/your-org/granity"
  spec.summary     = "Granity Rails Engine"
  spec.description = "Granity is a Rails engine providing reusable functionality."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/your-org/granity"
  spec.metadata["changelog_uri"] = "https://github.com/your-org/granity/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.0"

  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "database_cleaner-active_record"
end
