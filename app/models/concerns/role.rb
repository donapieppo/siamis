module Role
  extend ActiveSupport::Concern

  included do
    # same as user
    attr_accessor :email, :name, :surname, :affiliation, :address
  end

  private

  # for Organizer
  # for Author
  def set_or_create_user_from_email
    self.user_id and return true

    # without email noting interesting here
    if self.email.blank?
      self.errors.add(:email, 'Give email')  
    elsif _user = User.where(email: self.email).first 
      if self.is_a?(Organizer) and self.session_id and self.class.where(user_id: _user.id, session_id: self.session_id).any? 
        self.errors.add(:email, "User is already organizer of this #{self.session.class}")
      end
      self.user_id = _user.id 
    else
      _user = User.new(email:       self.email, 
                       name:        self.name, 
                       surname:     self.surname, 
                       affiliation: self.affiliation,
                       address:     self.address)
      if _user.save
        self.user_id = _user.id 
      end
    end
  end

end
