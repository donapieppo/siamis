class Schedule < ApplicationRecord
  belongs_to :conference_session
  belongs_to :room

  def to_s
    "#{I18n.l(self.start, format: :with_day_name)} in #{self.room}"
  end

  def start_day
    self.start
  end

  def start_hour
    self.start ? "#{self.start.hour}:#{self.start.min}" : Time.now
  end

  # start from 0
  def self.conference_day(num)
    ((num = num.to_i) < Rails.configuration.number_of_days) or raise "#{num} is not a conference day number"
    Rails.configuration.conference_start_date + num.days
  end

  def self.conference_days_array
    (0...Rails.configuration.number_of_days).map do |i|
      Rails.configuration.conference_start_date + i.days
    end
  end

  def self.days_array_for_select
    (0...Rails.configuration.number_of_days).map do |i|
      [I18n.l(Rails.configuration.conference_start_date + i.days, format: :schedule ), i]
    end
  end
end
