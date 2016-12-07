# frozen_string_literal: true
# rubocop:disable Metrics/BlockLength
ruby '2.3.1'

source 'https://rubygems.org' do
  gem 'active_decorator'
  gem 'cancancan'
  gem 'coffee-rails'
  gem 'config'
  gem 'devise'
  gem 'gon'
  gem 'google-api-client'
  gem 'jbuilder'
  gem 'jquery-rails'
  gem 'komachi_heartbeat'
  gem 'mysql2'
  gem 'omniauth'
  gem 'omniauth-google-oauth2'
  gem 'doorkeeper'
  gem 'puma'
  gem 'rails', '5.0.0.1'
  gem 'rinku', require: 'rails_rinku'
  gem 'rmail'
  gem 'sass-rails'
  gem 'slim-rails'
  gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
  gem 'uglifier'
  gem 'virtus'
  gem 'whenever', require: false

  group :production do
    gem 'sentry-raven'
    gem 'skylight'
  end

  group :development do
    gem 'binding_of_caller'
    gem 'annotate'
    gem 'better_errors'
    gem 'listen'
    gem 'rubocop', require: false
    gem 'spring'
    gem 'spring-watcher-listen'
    gem 'web-console'
    gem 'yard', require: false
  end

  group :test do
    gem 'capybara'
    gem 'capybara-screenshot'
    gem 'database_rewinder'
    gem 'json_expressions'
    gem 'launchy'
    gem 'poltergeist'
    gem 'rails-controller-testing'
    gem 'rspec-parameterized'
    gem 'rspec-rails'
    gem 'rspec_junit_formatter'
    gem 'simplecov', require: false
    gem 'validation_examples_matcher'
    gem 'vcr'
    gem 'webmock'
  end

  group :development, :test do
    gem 'bullet'
    gem 'byebug', platform: :mri
    gem 'factory_girl_rails'
    gem 'ffaker'
    gem 'pry-byebug'
    gem 'pry-rails'
  end
end
