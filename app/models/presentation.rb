class Presentation < ApplicationRecord
  has_many :authors, dependent: :destroy
  # has_many :users, through: :authors
  has_many :ratings, dependent: :destroy
  belongs_to :conference_session, optional: true
  belongs_to :minisymposium, foreign_key: :conference_session_id, optional: true
  belongs_to :minitutorial,  foreign_key: :conference_session_id, optional: true
  belongs_to :plenary,       foreign_key: :conference_session_id, optional: true

  scope :at_minisymposium, -> { left_outer_joins(:conference_session).where.not(conference_session_id: nil).where('conference_sessions.type = "Minisymposium"').references(:conference_session) }
  scope :at_minitutorial,  -> { left_outer_joins(:conference_session).where.not(conference_session_id: nil).where('conference_sessions.type = "Minitutorial"').references(:conference_session) }
  scope :at_plenary,       -> { left_outer_joins(:conference_session).where.not(conference_session_id: nil).where('conference_sessions.type = "Plenary"').references(:conference_session) }

  scope :unassigned,       -> { where(conference_session_id: nil) }
  scope :poster,           -> { where.not(poster: nil) }
  scope :not_poster,       -> { where(poster: nil) }

  scope :submitted,        -> { unassigned.where(accepted: nil) }
  scope :accepted,         -> { where(accepted: true) }

  validates :name, presence: true

  def to_s
    self.name || self.conference_session.to_s
  end

  def umbrella
    self.conference_session ? self.conference_session.class : ContributedSession
  end

  def lonely_in_session?
    self.conference_session.is_a?(Minitutorial) or self.conference_session.is_a?(Plenary)
  end

  def parent_event_abbr
    conference_session.code if conference_session
  end

  def parent_class
    conference_session.class_name if conference_session
  end

  def code 
    conference_session ? conference_session.code : '-'
  end

  def speaker
    self.authors.where(speak: true).first || self.authors.first
  end

  def speaker=(_author)
    self.authors.each do |a|
      a.update_attribute(:speak, a == _author)
    end
  end

  def speaker_id
    self.speaker.id
  end

  def speaker_id=(i)
    self.speaker = Author.find(i)
  end

  def authors_to_s
    self.authors.map(&:to_s).join(', ')
  end

  def accept!
    self.update_attribute(:accepted, true)
  end

  def refuse!
    self.update_attribute(:accepted, false)
  end

  def accepted?
    self.accepted and self.accepted == true
  end

  def schedule
    if self.conference_session and self.conference_session.schedule
      self.conference_session.schedule
    end    
  end

  def notify_acceptance
    self.authors.each do |author|
      author.notify_acceptance(self)
    end
  end

  def ratable?
    ! self.accepted
  end

  def class_name
    I18n.t(self.class.to_s)
  end
end


