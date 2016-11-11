class Role < ApplicationRecord
  belongs_to :user
  
  attr_accessor :email, :name, :surname, :affiliation, :address

  before_validation :set_or_create_user_from_email

  def to_s
    self.user.to_s
  end

  before_validation :set_or_create_user_from_email

  def to_s
    self.user.to_s
  end

  private

  def validate_if_has_already_same_role
   if self.is_a?(Organizer) and self.conference_session_id 
     self.errors.add(:email, "User is already organizer of this #{self.conference_session.class}") if Organizer.where(user_id: self.user_id, conference_session_id: self.conference_session_id).any?
   elsif self.is_a?(Chair) and self.conference_session_id
     self.errors.add(:email, "User is already chair of this #{self.conference_session.class}") if Chair.where(user_id: self.user_id, conference_session_id: self.conference_session_id).any?
   elsif self.is_a?(Author) and self.presentation_id 
     self.errors.add(:email, "User is already author of this #{self.presentation.class}") if Author.where(user_id: self.user_id, presentation_id: self.presentation_id).any?
   end
  end

  # for Organizer
  # for Author
  def set_or_create_user_from_email
    self.user_id and return true

    # without email noting interesting here
    if self.email.blank?
      self.errors.add(:email, 'Please enter email address')  
    elsif _user = User.where(email: self.email).first 
      self.user_id = _user.id 
      validate_if_has_already_same_role
    else
      self.name.blank?        and self.errors.add(:name, "Please enter the name of the user.") 
      self.surname.blank?     and self.errors.add(:surname, "Please enter the surname of the user.")
      self.affiliation.blank? and self.errors.add(:affiliation, "Please enter the affiliation of the user.")
      if self.errors.empty?
        generated_password = Devise.friendly_token.first(6)
        _user = User.new(email:        self.email, 
                         password:     generated_password,
                         name:         self.name, 
                         surname:      self.surname, 
                         affiliation:  self.affiliation,
                         address:      self.address, 
                         confirmed_at: Time.now)
        if _user.save
          RegistrationMailer.welcome(_user, generated_password, self).deliver
          self.user_id = _user.id 
        end
      end
    end
  end

end
