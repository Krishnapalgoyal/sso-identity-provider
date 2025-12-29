# config/initializers/acts_as_tenant.rb
ActsAsTenant.configure do |config|
  config.require_tenant = false  # Require tenant to be set
end
