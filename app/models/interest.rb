class Interest < ApplicationRecord
  belongs_to :user
  belongs_to :conference_session, optional: true
  belongs_to :presentation, optional: true

  # returns the new interest status
  def self.modify!(user, what)
    if interest = what.interests.where(user_id: user.id).first
      interest.destroy!
      return false
    else
      what.interests.create!(user_id: user.id)
    end
  end

  def on
    self.conference_session || self.presentation
  end
end

