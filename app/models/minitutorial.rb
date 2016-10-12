class Minitutorial < ApplicationRecord
  has_many :organizers

  def to_s
    self.name
  end
end


