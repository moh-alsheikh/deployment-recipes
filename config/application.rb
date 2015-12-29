require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TestDeployment
  class Application < Rails::Application
    config.time_zone = 'Riyadh'
    config.active_record.default_timezone = :local
    config.encoding = "utf-8"
    # Enable the asset pipeline
    config.assets.enabled = true
    config.active_record.raise_in_transactional_callbacks = true
  end
end
