class Presentation < ApplicationRecord
  has_many :authors
  has_many :users, through: :authors
  belongs_to :minisymposium, optional: true
  belongs_to :minitutorial,  optional: true
  has_many :ratings

  scope :at_minisymposium, -> { where.not(minisymposium_id: nil) }
  scope :at_minitutorial, -> { where.not(minitutorial_id: nil) }

  def to_s
    self.name
  end

  def parent_event
    self.minitutorial || self.minisymposium
  end

end

