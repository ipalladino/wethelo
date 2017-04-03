require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Wethelo
  class Application < Rails::Application

    config.active_record.raise_in_transactional_callbacks = true
    config.assets.cache_store = :null_store  # Disables the Asset cache
    config.sass.cache = false  # Disable the SASS compiler cache
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    #4. If you are deploying on Heroku with Rails 3.2 only, you may want to set:
    #config.assets.initialize_on_precompile = false

    config.paperclip_defaults = {
      storage: :s3,
      s3_credentials: {
        bucket: "wethelo",
        access_key_id: ENV.fetch('S3_KEY'),
        secret_access_key: ENV.fetch('S3_SECRET'),
        s3_region: ENV.fetch('S3_REGION'),
        s3_host_name: "s3-#{ENV['S3_REGION']}.amazonaws.com"
      }
    }

  end
end
