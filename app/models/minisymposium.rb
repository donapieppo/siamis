class Minisymposium < Session
  DURATION = 30

  validates :name, presence: true, uniqueness: true
end


