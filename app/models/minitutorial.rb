class Minitutorial < MonoConferenceSession

  alias chairs organizers

  def code
    "MT" + (self.number).to_s
  end

  def mono_session?
    true
  end
  
end


