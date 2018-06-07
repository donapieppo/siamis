class MultipleConferenceSession < ConferenceSession
  has_many :presentations, foreign_key: :conference_session_id, dependent: :destroy

  validates :name, presence: true

  scope :all_included, -> { includes(schedules: :room, presentations: [authors: :user], organizers: :user) }
end

