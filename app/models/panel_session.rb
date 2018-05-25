class PanelSession < MonoConferenceSession
  alias chairs organizers

  def code
    "PD" 
  end

  def mono_session?
    true
  end

  def author_label
    "Participant"
  end

  def code_with_part(p)
    "PD"
  end
end

