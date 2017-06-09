class InvitationLetter < ApplicationRecord
  belongs_to :user, required: true

  validates :passport_name, :birthdate, :passport_origin, :passport_number, :address, :city, :state, :zip, :country, presence: :true

end


