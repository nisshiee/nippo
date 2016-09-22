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
      render json: send_nippo
    else
      flash.now[:alert] = @nippo.errors.values.flatten
      render json: @nippo.errors.values.flatten
    end
  end

  def update
    if update_nippo
      render json: send_nippo
    else
      flash.now[:alert] = @nippo.errors.values.flatten
      render json: @nippo.errors.values.flatten
    end
  end

  def index
    @recent_nippos = Nippo
                         .where.not(sent_at: nil)
                         .order(sent_at: :desc)
                         .limit(100)
    render json: @recent_nippos
  end

  def show
    unless @nippo.sent?
      return render json: "error"
    end

    reaction = Reaction.find_or_create_by(user: current_user, nippo: @nippo)
    Reaction.increment_counter(:page_view, reaction.id)
    render json: reaction
  end

  private

  def send_nippo
    sender = NippoSender.new(nippo: @nippo)
    if sender.run
      '日報を送信しました'
    else
      sender.errors.full_messages
    end
  end

end
