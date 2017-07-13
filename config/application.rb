require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Myflix
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true

    config.assets.enabled = true
    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
    end

    config.autoload_paths << "#{Rails.root}/lib"
  end
end

Raven.configure do |config|
  config.dsn = 'https://a7e16289cceb430683b87d8c3303197c:9fe95bcaef4045f98de81f941ec79edd@sentry.io/191394'
end