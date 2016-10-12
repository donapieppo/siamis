class Organizer <  ApplicationRecord
  belongs_to :user
  belongs_to :minisymposium, optional: true
  belongs_to :minitutorial,  optional: true

  before_validation :organizer_user

  # same as user
  attr_accessor :email, :name, :surname, :affiliation, :address

  def to_s
    self.user.to_s
  end

  private

  def organizer_user
    self.user_id and return true

    # without email noting interesting here
    if self.email.blank?
      self.errors.add(:email, 'Give email')  
    elsif _user = User.where(email: self.email).first 
      if self.minisymposium_id and Organizer.where(user_id: _user.id, minisymposium_id: self.minisymposium_id).any? 
        self.errors.add(:email, "User is already organizer of this minisymposium")
      elsif self.minitutorial_id and Organizer.where(user_id: _user.id, minitutorial_id: self.minitutorial_id).any? 
        self.errors.add(:email, "User is already organizer of this minitutorial")
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
