class MultipleConferenceSession < ConferenceSession 
  has_many :presentations, foreign_key: :conference_session_id, dependent: :destroy

  validates :name, presence: true
end

