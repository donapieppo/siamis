module StyleHelper
  def show_schedule_session(schedule)
    cs = schedule.conference_session
    content_tag(:div, class: 'row') do 
      content_tag(:div, class: 'col-xs-3 col-md-2 label label-warning', style: 'font-size: 16px; font-weight: bold; padding-top: 1em; height: 3em') do
        link_to cs.code_with_part(schedule.part), conference_session_path(schedule.conference_session, part: schedule.part), remote: true
      end +
      content_tag(:div, class: 'col-xs-9 col-md-10') do
        link_to(conference_session_path(schedule.conference_session, part: schedule.part), remote: true) { cs.name } + "<br/>".html_safe +
        "<small>#{h schedule.room}</small>".html_safe 
      end
    end
  end
end

