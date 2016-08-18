# frozen_string_literal: true
# == Schema Information
#
# Table name: nippos
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  reported_for :date             not null
#  subject      :text(65535)
#  body         :text(65535)
#  sent_at      :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  status       :integer          default("draft"), not null
#
# Indexes
#
#  index_nippos_on_sent_at                   (sent_at)
#  index_nippos_on_user_id                   (user_id)
#  index_nippos_on_user_id_and_reported_for  (user_id,reported_for) UNIQUE
#
# Foreign Keys
#
#  fk_rails_91f86e392f  (user_id => users.id)
#

class Nippo < ApplicationRecord
  belongs_to :user

  enum status: {
    draft:   0,
    sending: 1,
    sent:    2,
  }

  validates :reported_for, presence: { message: '日付を正しく入力してください' }
  validates :reported_for, uniqueness: {
    scope: :user,
    message: ->(o, _) { "#{o.reported_for.strftime('%Y-%m-%d')} の日報は既に作成済みです" },
  }
  validates :body, presence: { message: '本文の入力は必須です' }
  validates_each :subject, :body do |record, attr, _value|
    if record.changed.member?(attr.to_s) && record.status_was != 'draft'
      record.errors[attr] << '送信済みの日報は編集できません'
    end
  end

  def dated_subject
    subject % reported_for.strftime('%Y/%m/%d')
  end

  def self.default_report_date(now = Time.zone.now)
    if now.saturday?
      now.to_date - 1
    elsif now.sunday?
      now.to_date - 2
    elsif now.monday? && now.hour < 10
      now.to_date - 3
    elsif now.hour < 10
      now.to_date - 1
    else
      now.to_date
    end
  end
end
