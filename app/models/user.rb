class User < ApplicationRecord
  devise :database_authenticatable, 
         :registerable,
         :recoverable, 
         :trackable, 
         :validatable,
         :confirmable
         # :rememberable, 

  has_many :roles, dependent: :destroy
  has_many :authors, dependent: :destroy
  has_many :organizers, dependent: :destroy

  has_many :conference_sessions, through: :organizers
  has_many :minisymposia,        through: :organizers
  has_many :minitutorials,       through: :organizers
  has_many :presentations,       through: :authors
  has_many :ratings
  has_many :payments
  has_many :manual_payments
  has_many :interests, dependent: :destroy

  has_one  :conference_registration
  has_one  :invitation_letter

  validates :email, uniqueness: { message: "The email is already registred." }
  validates :banquet_tickets, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  attr_accessor :privacy_policy

  scope :speakers, -> { where(id: Role.where('speak is true').pluck(:user_id)) }
  scope :student,  -> { where(student: true) }

  def to_s
    "#{self.cn} (#{self.affiliation})"
  end

  def cn
    # "#{self.salutation unless self.salutation.blank?} #{self.name} #{self.surname}"
    "#{self.name} #{self.surname}"
  end

  def cn_militar
    "%s %s" % [self.surname, self.name]
  end

  def cn_simple
    "#{self.name} #{self.surname}"
  end

  def owns!(what)
    self.owns?(what) or raise NoAccess
  end

  # user own 
  # 1) Minisymposium when organizer
  # 2) Plenary, Minitutorial only if organizer_committee
  # 3) presentation when 
  #   3.1) owns Minisymposium of the presentation
  #   3.2) is speaker (not author) and is possible to submit abstracts to minisymposium  presentations # FIXME also after
  def owns?(what)
    self.master_of_universe?     and return true
    self.in_organizer_committee? and return true

    case what
    when Minisymposium
      self.organizer?(what)
    when Plenary, Minitutorial
      false # only organizer_committee
    when Presentation
      case what.conference_session
      when Plenary, Minitutorial
        self.owns?(what.conference_session)
      when Minisymposium
        self.owns?(what.conference_session) || self.speaker?(what) # (Deadline.in_minisymposium_abstract? and self.speaker?(what))
      else
        self.speaker?(what) 
      end
    when Role
      self.owns?(what.conference_session || what.presentation)
    else
      false
    end
  end

  def master_of_universe?
    defined?(@__mofu) ? @__mofu : @__mofu = MASTERS_OF_UNIVERSE.include?(self.email)
  end

  def in_organizer_committee?
    defined?(@__iorc) ? @__iorc : @__iorc = ORGANIZER_COMMITTEE.include?(self.email)
  end

  def cochair?
    defined?(@__coch) ? @__coch : @__coch = COCHAIRS.include?(self.email)
  end

  def in_scientific_committee?
    defined?(@__scic) ? @__scic : @__scic = (SCIENTIFIC_COMMITTEE + COCHAIRS).include?(self.email)
  end

  def in_management_committee?
    defined?(@__manc) ? @__manc : @__manc = MANAGEMENT_COMMETTE.include?(self.email)
  end

  def in_local_committee?
    defined?(@__locc) ? @__locc : @__locc = LOCAL_COMMITTEE.include?(self.email)
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
    self.presentations.accepted.where('roles.speak': true).any? or self.conference_sessions.accepted.any? or self.in_organizer_committee?
  end

  def fee
    Fee.new(self)
  end

  def can_register?
    Deadline.registration_open? and self.payments.verified.empty? 
  end

  def speaks_in
    self.presentations.where('roles.speak': true)
  end

  def set_random_password
    generated_password = Devise.friendly_token.first(Rails.configuration.new_password_lenght)
    self.password = generated_password
    if self.save
      return generated_password
    else
      return false
    end
  end

  def activate_and_set_password
    self.confirmed? and return false
    if generated_password = self.set_random_password
      self.confirm
      return generated_password
    end
  end 

  def photo_asset
    unless self.email.blank?
      "speakers/#{self.email}.jpg"
    end
  end

  def interested_in?(what, part)
    what.interests.where(user_id: self.id, part: part).any?
  end

  ###################################################################

  def self.cochairs
    @@cochairs ||= User.where(email: COCHAIRS).order('surname, name')
  end

  def self.scientific_committee
    @@scientific_committee ||= User.where(email: SCIENTIFIC_COMMITTEE).order('surname, name')
  end

  def self.local_committee
    @@local_committee ||= User.where(email: LOCAL_COMMITTEE).order('surname, name')
  end

  # web page not here for link
  def self.safe_fields
    [:name, :surname, :affiliation, :country, :biography]
  end

  def self.all_fields
    self.safe_fields + [:address, :siag, :siam, :student, :student_confirmed, :staff, :exhibitor, :dietary, :banquet_tickets]
  end

  def self.partecipants
    active_ids  = Role.select(:user_id).map(&:user_id)
    visible_ids = User.where(visible: true).ids
    User.where(id: (active_ids + visible_ids).uniq)
  end
end


