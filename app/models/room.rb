class Room < ApplicationRecord
  belongs_to :building
  has_many :schedules

  validates :name, presence: true

  def to_s
    "#{self.name} (#{self.building.to_s} floor #{self.floor || 0})"
  end
end
