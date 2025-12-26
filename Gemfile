source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'


gem 'rails', '~> 6.0.3', '>= 6.0.3.6'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false

gem 'devise'                      # Authentication
gem 'apartment'                   # Multi-tenancy
gem 'ruby-saml'                   # SAML
gem 'omniauth-google-oauth2'      # Google OAuth
gem 'omniauth-rails_csrf_protection' # Security
gem 'pundit'                      # Authorization
gem 'kaminari'                    # Pagination
gem 'searchkick'                  # Elasticsearch
gem 'sidekiq'                     # Background jobs
gem 'redis'                       # Caching/sessions
gem 'bcrypt'                      # Password hashing


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'rspec-rails', '~> 5.1'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'dotenv-rails'
end

group :test do
  gem 'shoulda-matchers', '~> 5.0'
  gem 'database_cleaner-active_record'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
