class Minitutorial < ApplicationRecord
  has_many :organizers
  has_many :presentations
  has_many :ratings

  validates :name, uniqueness: true

  def to_s
    self.name
  end
end


