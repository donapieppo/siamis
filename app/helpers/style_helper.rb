module StyleHelper
  def show_schedule_session(schedule)
    cs = schedule.conference_session
    content_tag(:div, class: 'row conference_program_item') do 
      content_tag(:div, class: "#{conference_session_css_class(cs)} conference_program_item_name") do
        link_to cs.code_with_part(schedule.part), conference_session_path(cs, part: schedule.part), remote: true
      end +
      content_tag(:div, class: 'conference_program_item_description') do
        link_to(conference_session_path(schedule.conference_session, part: schedule.part), remote: true) { cs.name } + "<br/>".html_safe +
        "<small>#{h schedule.room}</small>".html_safe 
      end
    end
  end
end

