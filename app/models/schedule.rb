class Schedule < ApplicationRecord
  belongs_to :conference_session
  belongs_to :room

  def presentations
    self.conference_session.presentations.where(part: self.part)
  end

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
    self.start ? "#{'%02d' % self.start.hour}:#{'%02d' % self.start.min}" : Time.now
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
    Schedule.where('DATE_FORMAT(schedules.start, "%Y-%m-%d") = ?', day.strftime('%F'))
            .includes(conference_session: [presentations: [authors: :user]], room: :building)
            .order('schedules.start')
  end

  # res["08:00"] = [ { presentation: p, speaker: user, conference_session: cs, end: end}, ... ]
  def self.day_program_hour_hash(day)
    res = Hash.new
    self.day_program(day).each do |schedule|
      hour = schedule.start
      room = schedule.room
      conference_session = schedule.conference_session

      schedule.presentations.each do |presentation|
        hour = hour + conference_session.duration.minutes
        hour_str = hour.strftime("%H:%M")
        res[hour_str] ||= Array.new
        res[hour_str] << { presentation:       presentation,
                           speaker:            presentation.speaker.user,
                           conference_session: presentation.conference_session,
                           room:               room,
                           end:                (hour + conference_session.duration.minutes).strftime("%H:%M") }
      end
    end
    res
  end
end
