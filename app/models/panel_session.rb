class PanelSession < MonoConferenceSession
  alias chairs organizers

  def code
    "PD#{self.number || ""}" 
  end

  def mono_session?
    true
  end

  def author_label
    "Participant"
  end

  # many speakers
  def speakers(part = nil)
    self.presentation.authors.where(speak: 1)
  end
end

