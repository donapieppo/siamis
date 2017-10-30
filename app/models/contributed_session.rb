class ContributedSession < MultipleConferenceSession
  has_many :presentations, foreign_key: :conference_session_id, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def code
    "CP" + (self.number).to_s
  end

  def accepted?
    true
  end
end
