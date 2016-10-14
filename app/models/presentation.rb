class Presentation < ApplicationRecord
  has_many :speakers
  has_many :users, through: :speakers
  belongs_to :minisymposium, optional: true
  belongs_to :minitutorial,  optional: true
  has_many :ratings

  def to_s
    self.name
  end

  def parent_event
    self.minitutorial || self.minisymposium
  end

end

