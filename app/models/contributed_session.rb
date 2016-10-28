class ContributedSession < ConferenceSession
  DURATION = 10

  validates :name, presence: true, uniqueness: true
end
