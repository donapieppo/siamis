class Minisymposium < ConferenceSession
  has_many :presentations, foreign_key: :conference_session_id, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :submitted, -> { where(accepted: nil) }
  scope :accepted,  -> { where(accepted: true) }

  def presentations_complete
    self.presentations.size >= 4
  end

  def code
    "MS" + (self.number).to_s
  end

  def ratable?
    true
  end
end


