class ConferenceRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :payment, optional: true

  def to_s
    "Registration by #{self.user}"
  end
end
