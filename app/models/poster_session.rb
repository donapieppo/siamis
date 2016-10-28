class PosterSession < ConferenceSession
  DURATION = 50

  validates :name, presence: true, uniqueness: true
end
