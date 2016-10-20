class User < ApplicationRecord
  has_many :admins
  has_many :organizers
  has_many :minisymposia,  through: :organizers
  has_many :minitutorials, through: :organizers
  has_many :authors
  has_many :presentations, through: :authors
  has_many :ratings
  has_many :payments
  has_one  :registration

  validates :email,   uniqueness: true
  validates :name,    presence: true
  validates :surname, presence: true

  def to_s
    "#{self.name} #{self.surname} (#{self.affiliation})"
  end

  def owns!(what)
    self.owns?(what) or raise NoAccess
  end

  def owns?(what)
    self.master_of_universe? and return true
    self.committee_organizer? and return true
    case what
    when Minisymposium, Minitutorial
      self.organizer?(what)
    #when Author
    #  self.owns? (what.minitutorial || what.minisymposium)
    when Presentation
      what.user_ids.include?(self.id)
    else
      false
    end
  end

  def master_of_universe?
    MASTERS_OF_UNIVERSE.include?(self.email)
  end

  def committee_organizer?
    ORGANIZER_COMMITTEE.include?(self.email)
  end

  # minisymposium
  # minitutorial
  def organizer?(what)
    what.organizers.where(user_id: self.id).any?
  end

  def speaker_or_organizer?
    self.presentations.any? or self.organizers.any? or self.committee_organizer?
  end

  def fee
    Fee.new(self)
  end

  def can_register?
    # FIXME mettere date
    ! self.payments.verified.any?
  end

end

