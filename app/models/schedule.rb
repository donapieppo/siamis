class Schedule < ApplicationRecord
  belongs_to :conference_session
  belongs_to :room

  def to_s
    "#{I18n.l(self.start, format: :with_day_name)} in #{self.room}"
  end

  def start_day_number
    if self.start
      (self.start.to_date - Rails.configuration.conference_start_date).to_i
    end
  end

  def start_day
    self.start.to_date if self.start
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
    Rails.configuration.conference_start_date ... (Rails.configuration.conference_start_date + Rails.configuration.number_of_days.days)
  end

  def self.days_array_for_select
    self.conference_days_array.map.with_index do |day, i|
      [I18n.l(day, format: :schedule ), i]
    end
  end

  def self.day_program(day)
    ConferenceSession.includes(:schedule)
                     .where('DATE_FORMAT(schedules.start, "%Y-%m-%d") = ?', day.strftime("%F"))
                     .order('schedules.start')
  end

  # res["08:00"] = [ session1, session2 ]
  def self.day_program_hour_hash(day)
    res = Hash.new
    self.day_program(day).each do |conference_session|
      hour = conference_session.schedule.start.strftime("%H:%S")
      res[hour] ||= Array.new
      res[hour] << conference_session
    end
    res
  end
end
