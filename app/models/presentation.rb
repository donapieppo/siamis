class Presentation < ApplicationRecord
  has_many :authors, dependent: :destroy
  has_many :users, through: :authors
  has_many :ratings
  belongs_to :conference_session, optional: true
  belongs_to :minisymposium, foreign_key: :conference_session_id, optional: true
  belongs_to :minitutorial,  foreign_key: :conference_session_id, optional: true

  scope :at_minisymposium, -> { left_outer_joins(:conference_session).where.not(conference_session_id: nil).where('conference_sessions.type = "Minisymposium"').references(:conference_session) }
  scope :at_minitutorial,  -> { left_outer_joins(:conference_session).where.not(conference_session_id: nil).where('conference_sessions.type = "Minitutorial"').references(:conference_session) }

  scope :unassigned,       -> { where(conference_session_id: nil) }

  def to_s
    self.name
  end

  def umbrella
    self.conference_session ? self.conference_session.class : ContributedSession
  end

  def parent_event_abbr
    case conference_session
    when Minisymposium
      'MS'
    when Minitutorial
      'MT'
    when PosterSession
      'PP'
    # ContributedConferenceSession
    else
      self.poster ? 'PP' : 'CP'
    end
  end

  def speaker
    self.authors.where(speak: true).first
  end
end

