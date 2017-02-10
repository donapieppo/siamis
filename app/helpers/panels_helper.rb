module PanelsHelper

  def session_heading(what)
    content_tag(:div, class: 'panel-heading') do
      content_tag(:h3) do
        link_to(what, what) +
        content_tag(:span, what.code, class: 'badge pull-right')
      end
    end
  end

  def presentation_parent(presentation)
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

  # what = presentation or minisymposium
  def panel_actions(what)
    return "&nbsp;".html_safe unless (current_user_owns?(what) or user_in_organizer_commettee?)

    link_to(icon('pencil') + ' edit', [:edit, what], class: :button) + " " +

    # plenary, minitutorial
    if what.respond_to?(:chairs) and what.is_a?(Plenary)
      link_to(icon('plus') + ' add chair', [:new, what, :chair], class: :button) 
    end + " " +

    if what.respond_to?(:organizers) 
      link_to icon('plus') + ' add organizer', [:new, what, :organizer], class: :button
    end + " " +

    if what.respond_to?(:authors) 
      link_to icon('plus') + ' add author', [:new, what.respond_to?(:presentation) ? what.presentation : what, :author], class: :button 
    end + " " +

    if what.respond_to?(:presentations)
      link_to icon('file-audio-o') + ' add presentation', [:new, what, :presentation], class: :button
    end + " " +

    link_to_delete('delete', what, button: true) + " " +

    if what.try(:conference_session)   
       link_to icon('reply') + " back to #{what.conference_session.class}", what.conference_session
    end + " " +

    if user_in_organizer_commettee? and ! what.is_a?(Presentation)
      link_to(icon('clock-o') + ' schedule', new_conference_session_schedule_path(what), class: :button) 
    end + " " +

    " "
  end
end

