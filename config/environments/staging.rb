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
  config.action_mailer.default_url_options = { host: "https://pkuttiya-myflix-staging.herokuapp.com/" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.mailtrap.io',
    domain:               'smtp.mailtrap.io',
    port:                 '2525',
    user_name:            ENV['MAILTRAP_USERNAME'],
    password:             ENV['MAILTRAP_PASSWORD'],
    authentication:       :cram_md5,
  }
end