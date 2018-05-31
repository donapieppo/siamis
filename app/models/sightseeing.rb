class Sightseeing < ApplicationRecord
  has_many :bookings

  validates :seats, numericality: { greater_than: 0 }

  def seats_left
    self.seats - self.bookings.sum(:number)
  end
end

