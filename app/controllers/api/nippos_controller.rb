# frozen_string_literal: true
class Api::NipposController < Api::ApiController
  include NippoHandleable

  def new
    @nippo = Nippo.new(
        body: current_user.template.body,
        reported_for: Nippo.default_report_date,
    )
    render json: @nippo
  end

  def create
    if @nippo.save
      send_nippo
    else
      flash.now[:alert] = @nippo.errors.values.flatten
      render :new
    end
  end

  def update
    if update_nippo
      send_nippo
    else
      flash.now[:alert] = @nippo.errors.values.flatten
      render :show
    end
  end

  def index
    @recent_nippos = Nippo
                     .where.not(sent_at: nil)
                     .order(sent_at: :desc)
                     .limit(100)
    render json: @recent_nippos
  end
end
