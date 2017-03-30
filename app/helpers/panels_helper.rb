module PanelsHelper

  def panel_heading(what)
    content_tag(:div, class: 'panel-heading') do
      content_tag(:h4) do
        h(what.to_s) + content_tag(:span, what.code, class: 'panel-header-code')
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
        concat content_tag(:small, "organized by: ".html_safe + show_roles(presentation.conference_session.organizers)) + "."
      end
    end
  end

  # what = presentation or minisymposium
  def panel_actions(what)
    return "&nbsp;".html_safe unless current_user

    common_actions(what) +
    owner_actions(what) +
    scientific_committee_actions(what) +
    organizer_committee_actions(what)
  end

end

