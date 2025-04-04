require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Amazon
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

     # Configuration for the application, engines, and railties goes here.
     #
     # These settings can be overridden in specific environments using the files
     # in config/environments, which are processed later.
     #
     # config.time_zone = "Central Time (US & Canada)"
     # config.eager_load_paths << Rails.root.join("extras")
     config.stripe.secret_key = ENV["sk_test_51QpWtpCKHyDovAIV4VUAPn5nSjZBKSzZhJZDGDK94hGYCnpkUrkuNOqHA64Io9O5l51TOARU91MteYMtEiY2d5vX00x7zv3fOe"]
     config.stripe.publishable_key = ENV["pk_test_51QpWtpCKHyDovAIVPmzcIh8oTq4SRZaffv2AB4hQUkNPiSmKdXkQ0De1JKHYXoHdsyv83ikB5SfQspJcx6ccLUYq00DVU9nMrp"]
    # config.session_store :cookie_store, key: "_your_app_session"
  end
end
