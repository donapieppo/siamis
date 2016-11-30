class Minisymposium < ConferenceSession
  DURATION = 30

  has_many :presentations, foreign_key: :conference_session_id, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def presentations_complete
    self.presentations.size >= 4
  end
end


