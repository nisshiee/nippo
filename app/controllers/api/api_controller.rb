# frozen_string_literal: true
class Api::ApiController < ApplicationController
  before_action :doorkeeper_authorize!
  helper_method :current_user

  def current_user
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
