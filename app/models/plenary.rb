class Plenary < MonoConferenceSession

  alias chairs organizers

  def code
    "IP#{self.number || ""}" 
  end

  def mono_session?
    true
  end
end
