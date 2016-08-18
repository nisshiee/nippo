# frozen_string_literal: true
if Rails.env.production?
  Raven.configure do |config|
    config.dsn = Settings.sentry.private_dsn
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
    config.excluded_exceptions = %w(
      ActionController::RoutingError
      CGI::Session::CookieStore::TamperedWithCookie
    )
  end
end
