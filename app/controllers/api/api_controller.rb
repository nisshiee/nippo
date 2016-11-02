# frozen_string_literal: true
class Api::ApiController < ApplicationController
  before_action :doorkeeper_authorize!
  helper_method :current_user
  protect_from_forgery with: :null_session

  rescue_from CanCan::AccessDenied do |_|
    raise ActionController::RoutingError, 'Not Found'
  end

  def current_user
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
