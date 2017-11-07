class Minisymposium < MultipleConferenceSession

  def code
    "MS" + (self.number).to_s
  end

  def ratable?
    true
  end

  def organizers_label
    "Organizers"
  end

end


