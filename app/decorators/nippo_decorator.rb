# frozen_string_literal: true
module NippoDecorator
  def date_notice
    return unless needs_date_notice?

    today = Time.zone.today
    if reported_for == today
      content_tag(:p, '← 今日の日付です', class: 'date-notice')
    elsif reported_for == today - 1
      content_tag(:p, '← 昨日の日付です', class: 'date-notice')
    elsif reported_for < today && reported_for.friday?
      content_tag(:p, '← 金曜日の日付です', class: 'date-notice')
    end
  end

  private

  def needs_date_notice?
    return false unless reported_for
    return false if persisted?

    now = Time.zone.now
    return true if now.saturday? || now.sunday?

    now.hour < 14
  end
end
