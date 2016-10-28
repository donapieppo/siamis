class PosterSession < Session
  DURATION = 50

  validates :name, presence: true, uniqueness: true
end
