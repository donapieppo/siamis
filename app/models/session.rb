class Session < ApplicationRecord
  has_many :organizers, dependent: :destroy
  has_one  :chair, class_name: User, foreign_key: :chair_id
  has_many :presentations # FIXME dependent FIXME minitutorial
  has_many :ratings, dependent: :destroy
  has_one  :schedule

  def to_s
    self.name
  end

  def duration 
    DURATION
  end
end



