class Minisymposium < MultipleConferenceSession
  validates :name, presence: true, uniqueness: true

  scope :submitted, -> { where(accepted: nil) }
  scope :accepted,  -> { where(accepted: true) }

  def code
    "MS" + (self.number).to_s
  end

  def ratable?
    true
  end

  def organizers_label
    "Organizers"
  end

  def accepted?
    self.accepted
  end
end


