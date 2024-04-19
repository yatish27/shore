source "https://rubygems.org"

ruby file: ".ruby-version"

gem "vite_rails", "~> 3.0"
gem "rails", "~> 7.1.3", ">= 7.1.3.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "dotenv", ">= 3.0"
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "brakeman", require: false
  gem "web-console"
end
