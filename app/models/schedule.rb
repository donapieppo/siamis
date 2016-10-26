class Schedule < ApplicationRecord
  belongs_to :session
  belongs_to :room

  def to_s
    "#{I18n.l self.start} in #{self.room}"
  end

  def start_day
    #self.start - Rails.configuration.start_date
    self.start
  end

  def start_hour
    self.start ? "#{self.start.hour}:#{self.start.min}" : Time.now
  end
end
