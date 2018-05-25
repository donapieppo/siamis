class PanelSession < MonoConferenceSession
  alias chairs organizers

  def code
    "PS" 
  end

  def mono_session?
    true
  end

  def author_label
    "Participant"
  end

  def code_with_part(p)
    "PS"
  end
end

