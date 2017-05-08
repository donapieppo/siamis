class Plenary < MonoConferenceSession

  def code
    "IP#{self.number || ""}" 
  end

  alias chairs organizers

end
