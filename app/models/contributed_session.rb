class ContributedSession < ConferenceSession
  DURATION = 10

  has_many :presentations, foreign_key: :conference_session_id, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
