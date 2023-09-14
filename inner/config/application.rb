require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

class ChipsMiddelware
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env).tap do |status, headers, body|
      enable_chips! headers
    end
  end

  private

  def enable_chips!(headers)
    if cookies = headers["Set-Cookie"]
      cookies = cookies.split("\n")

      headers["Set-Cookie"] = cookies.map { |cookie|
        "#{cookie}; Partitioned"
      }.join("\n")
    end
  end
end

module Inner
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    if ENV["TUNNEL"]
      config.hosts << "inner.tonyta.dev"
      config.hosts << "inner.tonyta.org"
      config.force_ssl = true

      # Do not automatically set cookies as secure when using HTTPS
      config.ssl_options = { secure_cookies: false }
    else
      config.hosts << "innerhost"
    end

    config.middleware.insert_before 0, ChipsMiddelware if ENV["ENABLE_CHIPS"]
    config.session_store :cookie_store, key: 'session_id', secure: true, same_site: :none

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
