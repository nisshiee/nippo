# frozen_string_literal: true
class Api::NipposController < Api::ApiController
  include NippoHandleable

  def index
    @recent_nippos = Nippo
                     .where.not(sent_at: nil)
                     .order(sent_at: :desc)
                     .limit(100)
    render json: @recent_nippos
  end
end
