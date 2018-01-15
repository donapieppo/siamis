class Plenary < MonoConferenceSession

  def code
    "IP#{self.number || ""}" 
  end

  alias chairs organizers

  def mono_session?
    true
  end
end
