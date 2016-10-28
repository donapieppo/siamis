class Minisymposium < ConferenceSession
  DURATION = 30

  validates :name, presence: true, uniqueness: true
end


