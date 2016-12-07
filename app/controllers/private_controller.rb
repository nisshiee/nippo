# frozen_string_literal: true
class PrivateController < ApplicationController
  layout 'private'
  before_action :authenticate_user!
  before_action :set_private_raven_context if Rails.env.production?

  rescue_from CanCan::AccessDenied do |_|
    raise ActionController::RoutingError, 'Not Found'
  end

  private

  def set_private_raven_context
    Raven.user_context(id: current_user.id)
  end
end
