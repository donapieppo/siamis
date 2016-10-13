class Minisymposium < ApplicationRecord
  has_many :organizers
  has_many :presentations

  validates :name, uniqueness: true

  def to_s
    self.name
  end

end


