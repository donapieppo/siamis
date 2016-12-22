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

end

