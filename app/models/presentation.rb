class Presentation < ApplicationRecord
  has_many :speakers
  belongs_to :minisymposium, optional: true
  belongs_to :minitutorial,  optional: true

  def to_s
    self.name
  end
end

