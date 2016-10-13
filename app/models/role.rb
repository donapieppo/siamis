class Role < ApplicationRecord
  belongs_to :user

  before_validation :set_or_create_user_from_email

  # same as user
  attr_accessor :email, :name, :surname, :affiliation, :address

  def to_s
    self.user.to_s
  end

  private

  def set_or_create_user_from_email
    self.user_id and return true

    # without email noting interesting here
    if self.email.blank?
      self.errors.add(:email, 'Give email')  
    elsif _user = User.where(email: self.email).first 
      if self.minisymposium_id and self.class.where(user_id: _user.id, minisymposium_id: self.minisymposium_id).any? 
        self.errors.add(:email, "User is already organizer of this minisymposium")
      elsif self.minitutorial_id and self.class.where(user_id: _user.id, minitutorial_id: self.minitutorial_id).any? 
        self.errors.add(:email, "User is already organizer of this minitutorial")
      elsif self.presentation_id and self.class.where(user_id: _user.id, presentation_id: self.presentation_id).any? 
        self.errors.add(:email, "User is already speaker of this presentation")
      end
      self.user_id = _user.id 
    else
      _user = User.new(email: self.email, 
                       name: self.name, 
                       surname: self.surname, 
                       affiliation: self.affiliation,
                       address: self.address)
      if _user.save
        self.user_id = _user.id 
      end
    end
  end
end
