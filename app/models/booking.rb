class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :sightseeing

  validates :number, numericality: { greater_than: 0 }
  validates :sightseeing_id, uniqueness: { scope: [:user_id], message: "Already booked by you." }
  # validate  :check_enough

  def check_enough
    if Booking.where(sightseeing_id: self.sightseeing_id).sum(:number) > self.sightseeing.seats_left
      errors.add(:number, "Not enought seats left for your request.")
      throw :abort
    end
  end
end
