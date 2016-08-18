# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_application_raven_context if Rails.env.production?
  before_action :enable_js_raven               if Rails.env.production?

  private

  def set_application_raven_context
    Raven.extra_context(params: params.to_h, url: request.url)
  end

  def enable_js_raven
    gon.raven = {
      dsn: Settings.sentry.public_dsn,
    }
  end
end
