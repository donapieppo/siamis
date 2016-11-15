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
end
