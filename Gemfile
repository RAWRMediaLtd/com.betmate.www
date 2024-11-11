source "https://rubygems.org"

ruby "3.2.0"

gem "rails", "~> 7.1.3", ">= 7.1.3.4"
gem "sprockets-rails"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "sqlite3", "~> 1.4"
end

group :development do
  gem "web-console"
end

group :test do
  gem "webmock"
end

group :production do
  gem "pg", "~> 1.5"
  gem "postgresql", "~> 1.0"
end

gem "httparty", "~> 0.22.0"
gem "jquery-rails", "~> 4.6"
gem "dotenv", "~> 3.1"
gem "jsbundling-rails", "~> 1.3"
gem "cssbundling-rails", "~> 1.4"
gem "devise", "~> 4.9"
gem "babosa", "~> 2.0"
