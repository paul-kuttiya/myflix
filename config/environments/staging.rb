Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  #mailer config
  config.action_mailer.default_url_options = { host: "https://p-kuttiya-myflix.herokuapp.com/" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp-relay.sendinblue.com',
    port:                 587,
    domain:               'https://p-kuttiya-myflix.herokuapp.com/',
    user_name:            ENV['SEND_IN_BLUE_USERNAME'],
    password:             ENV['SEND_IN_BLUE_PASSWORD'],
    authentication:       :login,
    enable_starttls_auto: true
  }
end

Raven.configure do |config|
  config.dsn = ENV['RAVEN_DSN']
end