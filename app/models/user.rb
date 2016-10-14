class User < ApplicationRecord
  has_many :admins
  has_many :organizers
  has_many :minisymposia,  through: :organizers
  has_many :minitutorials, through: :organizers
  has_many :speakers
  has_many :presentations, through: :speakers

  validates :email,   uniqueness: true
  validates :name,    presence: true
  validates :surname, presence: true

  def to_s
    "#{self.name} #{self.surname}, #{self.affiliation}"
  end

  def owns!(what)
    self.owns?(what) or raise NoAccess
  end

  def owns?(what)
    self.master_of_universe? and return true
    self.organizer? and return true
    case what
    when Minisymposium, Minitutorial
      what.organizers.where(user_id: self.id).any?
    when Speaker
      self.owns? (what.minitutorial || what.minisymposium)
    when Presentation
      what.user_ids.include?(self.id)
    else
      false
    end
  end

  def master_of_universe?
    MASTERS_OF_UNIVERSE.include?(self.email)
  end

  def organizer?
    ORGANIZER_COMMITTEE.include?(self.email)
  end
end

