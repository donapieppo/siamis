class Role < ApplicationRecord
  belongs_to :user
  belongs_to :presentation, optional: true
  belongs_to :conference_session, optional: true
  
  attr_accessor :email, :name, :surname, :affiliation, :address

  before_validation :set_or_create_user_from_email

  scope :speakers_and_organizers, -> { where('(type = "Author" and speak=1) or type="Organizer"') }

  def to_s
    self.user.to_s
  end

  def cn
    self.user.cn
  end

  def relative_to
    self.conference_session || self.presentation
  end

  private

  def validate_if_has_already_same_role
    case self
    when Organizer
      if self.conference_session and self.conference_session.organizers.where(user_id: self.user_id).any?
        self.errors.add(:email, "User is already organizer of this #{self.conference_session.class}") 
      end
    when Author
      if self.presentation and self.presentation.authors.where(user_id: self.user_id).any?
        self.errors.add(:email, "User is already author of this #{self.presentation.class}") 
      end
    end
  end

  # for Organizer
  # for Author
  # SKIP_CONFIRMATION!
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
        _user = User.new(email:        self.email, 
                         password:     Devise.friendly_token.first(16), # FIXME 
                         name:         self.name, 
                         surname:      self.surname, 
                         affiliation:  self.affiliation,
                         address:      self.address) # confirmed_at: Time.now)
        # create by other user, not by anonymous 
        _user.skip_confirmation!
        if _user.save
          self.user_id = _user.id 
        else
          Rails.logger.info("set_or_create_user_from_email errors: #{_user.errors.inspect}")
        end
      end
    end
  end
end
