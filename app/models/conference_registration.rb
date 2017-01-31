class ConferenceRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :payment

  def to_s
    "Registration by #{self.user}"
  end
end
