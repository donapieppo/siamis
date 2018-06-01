class Interest < ApplicationRecord
  belongs_to :user
  belongs_to :conference_session, optional: true
  belongs_to :presentation, optional: true

  # returns the new interest status
  def self.modify!(user, what, part)
    user_interests_in_what = what.interests.where(user_id: user.id)
    user_interests_in_what = user_interests_in_what.where(part: part) if part
    if interest = user_interests_in_what.first
      interest.destroy!
      return false
    else
      what.interests.create!(user_id: user.id, part: part)
    end
  end

  def self.conference_sessions_for_all
    ConferenceSession.plenary_or_panel
  end

  def on
    self.conference_session || self.presentation
  end

  def day
    cs = self.conference_session
    cs.schedules.where(part: self.part).first.start.to_date
  end

  def start
    cs = self.conference_session
    cs.schedules.where(part: self.part).first.start
  end

  def schedule
    self.conference_session.schedules.where(part: self.part).first
  end
end

