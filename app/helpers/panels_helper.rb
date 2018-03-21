module PanelsHelper

  def panel_heading(what)
    content_tag(:div, class: 'panel-heading') do
      content_tag(:h4) do
        h(what.name) + content_tag(:span, what.code, class: 'panel-header-code')
      end
    end
  end

  def presentation_parent(presentation)
    (cs = presentation.conference_session) or return ""
    content_tag(:p) do
      concat "This presentation is part of "
      concat content_tag(:strong, h(t(cs.class)) + " &ldquo;".html_safe) 
      concat content_tag(:em, link_to(cs, cs)) 
      concat "&rdquo; ".html_safe
      concat "<br/>".html_safe 
      if cs.is_a?(Minisymposium) 
        concat content_tag(:small, "organized by: ".html_safe + show_roles(cs.organizers)) + "."
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

  def missing_presentations_alert
    content_tag(:p, class: "alert alert-warning") do
      icon('warning') + 
      t(:minisymposium_presentation_number_warning).html_safe +
      "<br/>Please <strong>add presentations</strong> with the button below.".html_safe
    end
  end

end

