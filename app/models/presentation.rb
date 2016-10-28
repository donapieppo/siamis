class Presentation < ApplicationRecord
  has_many :authors, dependent: :destroy
  has_many :users, through: :authors
  has_many :ratings
  belongs_to :session, optional: true
  belongs_to :minisymposium, foreign_key: :session_id, optional: true
  belongs_to :minitutorial,  foreign_key: :session_id, optional: true

  scope :at_minisymposium, -> { left_outer_joins(:session).where.not(session_id: nil).where('sessions.type = "Minisymposium"').references(:session) }
  scope :at_minitutorial,  -> { left_outer_joins(:session).where.not(session_id: nil).where('sessions.type = "Minitutorial"').references(:session) }

  scope :unassigned,       -> { where(session_id: nil) }

  def to_s
    self.name
  end

  def umbrella
    self.session ? self.session.class : ContributedSession
  end

  def parent_event_abbr
    case session
    when Minisymposium
      'MS'
    when Minitutorial
      'MT'
    when PosterSession
      'PP'
    # ContributedSession
    else
      'CP'
    end
  end

  def speaker
    self.authors.where(speak: true).first
  end
end

