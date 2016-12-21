class PosterSession < ConferenceSession
  DURATION = 50

  has_many :presentations, foreign_key: :conference_session_id, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def code
    "PP" + (self.number).to_s
  end
end
