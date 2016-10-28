class Minitutorial < Session
  DURATION = 20

  # can have no name
  def to_s
    if self.name.blank?
      self.presentations.first.to_s || "Minitutorial"
    else
      self.name
    end
  end

  def description_or_abstract
    self.description || self.presentations.first.try(:abstract) || "Minitutorial"
  end
end


