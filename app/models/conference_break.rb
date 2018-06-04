class ConferenceBreak < MonoConferenceSession
  def code
    "BR" 
  end

  def mono_session?
    true
  end

  def author_label
  end

  def code_with_part(p)
    "BR"
  end
end


