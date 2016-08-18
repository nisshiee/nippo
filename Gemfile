# frozen_string_literal: true
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
  gem 'mysql2'
  gem 'omniauth'
  gem 'omniauth-google-oauth2'
  gem 'doorkeeper'
  gem 'puma'
  gem 'rails', '5.0.0'
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
    gem 'bullet', group: :test
    gem 'byebug', platform: :mri, group: :test
    gem 'listen'
    gem 'pry-byebug', group: :test
    gem 'pry-rails', group: :test
    gem 'rubocop', require: false
    gem 'spring'
    gem 'spring-watcher-listen'
    gem 'web-console'
  end

  group :test do
    gem 'capybara'
    gem 'capybara-screenshot'
    gem 'database_rewinder'
    gem 'factory_girl_rails', group: :development
    gem 'ffaker',             group: :development
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

  group :doc do
    gem 'yard'
  end
end
