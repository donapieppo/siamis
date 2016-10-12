class Minisymposium < ApplicationRecord
  has_many :organizers
  has_many :proposal_users

  validates :name, uniqueness: true

  attr_accessor :organizer

  def to_s
    self.name
  end

end


