module PanelsHelper

  def panel_heading(what)
    content_tag(:div, class: 'panel-heading') do
      content_tag(:h3) do
        link_to(what, what) +
        content_tag(:span, what.code, class: 'panel-header-code')
      end
    end
  end

  def presentation_parent(presentation)
    presentation.conference_session or return ""
    content_tag(:p) do
      concat "This presentation is part of " 
      concat content_tag(:strong, h(t(presentation.conference_session.class)) + " ") 
      concat content_tag(:em, link_to(presentation.conference_session, presentation.conference_session)) 
      concat "<br/>".html_safe 
      if presentation.conference_session.is_a?(Minisymposium) 
        concat content_tag(:small, organized_by(presentation.conference_session)) + "."
      end
    end
  end

  def common_actions(what)
    return "&nbsp;".html_safe if user_in_organizer_commettee?

    actual = current_user.interested_in?(what) ? "not" : ""
    case what
    when Minisymposium, ConferenceSession
      link_to icon('eye') + " I'm #{actual} interested", interested_conference_session_path(what), class: :button
    when Presentation, PosterSession
      link_to icon('eye') + " I'm #{actual} interested", interested_presentation_path(what), class: :button
    end
  end

  def owner_actions(what)
    return "&nbsp;".html_safe unless current_user_owns?(what)

    capture do 
      concat(link_to icon('pencil') + ' edit', [:edit, what], class: :button)

      # plenary, minitutorial
      if what.respond_to?(:chairs) 
        concat(link_to icon('plus') + ' add chair', [:new, what, :organizer], class: :button)
      elsif what.is_a?(Minisymposium)
        concat(link_to icon('plus') + ' add organizer', [:new, what, :organizer], class: :button)
      end 

      if what.respond_to?(:authors) 
        concat(link_to icon('plus') + ' add author', [:new, what.respond_to?(:presentation) ? what.presentation : what, :author], class: :button)
      end 

      if what.respond_to?(:presentations)
        concat(link_to icon('file-audio-o') + ' add presentation', [:new, what, :presentation], class: :button)
      end 

      concat(link_to_delete('delete', what, button: true))

      if conference_session = what.try(:conference_session)   
        concat(link_to icon('reply') + " back to #{conference_session.class}", conference_session)
      end 
      "&nbsp;".html_safe
    end
  end

  def organizer_commettee_actions(what)
    return "&nbsp;".html_safe unless user_in_organizer_commettee?

    capture do 
      if what.is_a?(ConferenceSession)
        concat(link_to icon('clock-o') + ' schedule', new_conference_session_schedule_path(what), class: :button)
      end 

      if what.is_a?(ContributedSession) or what.is_a?(PosterSession)
        concat(link_to icon('list') + ' manage presentations', manage_presentations_conference_session_path(what))
      end

      if what.ratable?
        if what.accepted?
          concat(link_to icon('circle-o') + ' refuse', [:refuse, what], method: :put)
        else 
          concat(link_to icon('check') + ' accept',    [:accept, what], method: :put)
        end
      end

      "&nbsp;".html_safe
    end
  end

  def scientific_commettee_actions(what)
    capture do 
      if user_in_scientific_commettee? and what.ratable? and ! what.accepted?
        concat(link_to icon('star') + ' rate', [:new, what, :rating], remote: true)
      end 

      "&nbsp;".html_safe
    end
  end

  # what = presentation or minisymposium
  def panel_actions(what)
    common_actions(what) +
    owner_actions(what) +
    scientific_commettee_actions(what) +
    organizer_commettee_actions(what)
  end

end

