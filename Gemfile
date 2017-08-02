source 'https://rubygems.org'
ruby '2.2.7'

gem 'bootstrap-sass', '3.1.1.1'
gem 'coffee-rails'
gem 'rails', '4.1.9'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg', '0.20'
gem 'bootstrap_form'
gem 'bcrypt'
gem 'fabrication'
gem 'sidekiq', '4.2.10'
gem 'faker'
gem 'carrierwave'
gem 'mini_magick'
gem 'stripe'
gem 'figaro'
gem 'draper'

group :development do
  gem "awesome_print"
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  gem 'letter_opener'
  gem 'thin'
  gem 'guard'
  gem "rack-livereload"
  gem 'guard-livereload'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '~> 3.5'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'chromedriver-helper'
  gem 'database_cleaner', '1.4.1'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '2.7.0'
  gem 'vcr', '3.0.3'
  gem 'webmock'
  gem 'capybara-webkit'
end

group :development, :staging, :production do
  gem 'puma'
end

group :staging, :production do
  gem 'carrierwave-aws'
  gem 'rails_12factor'
  gem "sentry-raven"
end