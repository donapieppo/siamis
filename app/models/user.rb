class User < ApplicationRecord
  devise :database_authenticatable, 
         :registerable,
         :recoverable, 
         :trackable, 
         :validatable,
         :confirmable
         # :rememberable, 

  has_many :conference_sessions,  through: :organizers
  has_many :organizers
  has_many :minisymposia,  through: :organizers
  has_many :minitutorials, through: :organizers
  has_many :authors
  has_many :presentations, through: :authors
  has_many :ratings
  has_many :payments
  has_one  :conference_registration

  validates :email, uniqueness: { message: "The email is already registred." }

  def to_s
    "#{self.cn} (#{self.affiliation})"
  end

  def cn
    "#{self.salutation unless self.salutation.blank?} #{self.name} #{self.surname}"
  end

  def owns!(what)
    self.owns?(what) or raise NoAccess
  end

  def owns?(what)
    self.master_of_universe? and return true
    self.in_organizer_commettee? and return true

    case what
    when Minisymposium, Minitutorial
      self.organizer?(what)
    when Presentation
      self.speaker?(what) or self.owns?(what.conference_session)
    when Role
      self.owns?(what.conference_session || what.presentation)
    else
      false
    end
  end

  def master_of_universe?
    MASTERS_OF_UNIVERSE.include?(self.email)
  end

  def in_organizer_commettee?
    ORGANIZER_COMMITTEE.include?(self.email)
  end

  def in_scientific_committee?
    (SCIENTIFIC_COMMITTEE + COCHAIRS).include?(self.email)
  end

  # minisymposium
  # minitutorial
  def organizer?(what)
    what.organizers.where(user_id: self.id).any?
  end

  def author?(presentation)
    presentation.is_a?(Presentation) or return false
    presentation.authors.map(&:user_id).include?(self.id)
  end

  # FIXME
  def speaker?(presentation)
    presentation.authors.where(speak: true).where(user_id: self.id).any?
  end

  # FIXME
  def speaker_or_organizer?
    self.presentations.any? or self.organizers.any? or self.in_organizer_commettee?
  end

  def fee
    Fee.new(self)
  end

  def can_register?
    # FIXME mettere date
    Deadline.can_register? and self.payments.verified.empty?
  end

  def self.scientific_commettee
    @@cochairs ||= COCHAIRS.map{|email| User.where(email: email).first}
  end

  def self.cochairs
    @@scientific_commettee ||= SCIENTIFIC_COMMITTEE.map{|email| User.where(email: email).first}
  end

  def activate_and_set_password
    self.confirmed? and return
    generated_password = Devise.friendly_token.first(Rails.configuration.new_password_lenght)
    self.password = generated_password
    if self.save 
      self.confirm
      return generated_password
    end
  end 

  def self.safe_fields
    [:name, :surname, :affiliation, :country]
  end

  def self.all_fields
    self.safe_fields + [:address, :siag, :siam, :student]
  end

end


