source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 6.0"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "vite_rails", "~> 3.0"
gem "dotenv-rails", "~> 3.1"
gem "inertia_rails", "~> 3.8"
gem "js-routes", "~> 2.3"

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails", "~> 7.1"
  gem "standard", "~> 1.49"
  gem "parallel_tests", "~> 5.1"
  gem "capybara", "~> 3.40"
  gem "selenium-webdriver", "~> 4.31"
end

group :development do
  gem "web-console"
end
