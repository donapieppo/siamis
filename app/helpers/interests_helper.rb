module InterestsHelper
  def interest_id(what, part)
    "#{what.class.to_s.downcase}-#{what.id}-#{part}-interest"
  end

  def interest_link(what, part, interested = nil)
    return "" unless current_user
    interested = current_user.interested_in?(what, part) unless (interested == true || interested == false)
    link_path = case what
                when Minisymposium, ConferenceSession, PosterSession
                  toggle_conference_session_interests_path(what, part: part)
                when Presentation
                  toggle_presentation_interests_path(what)
                end
    link_to icon('star'), link_path, method: :post, class: (interested ? 'my-interest' : 'not-my-interest'), remote: true
  end
end


