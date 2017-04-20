module ActionsHelper

  def common_actions(what)
    return "&nbsp;".html_safe if current_user_owns?(what)
    # FIXME return "&nbsp;".html_safe if current_user and current_user.speaker?(what)

    now_icon = current_user.interested_in?(what) ? "star" : "star-o"
    title    = current_user.interested_in?(what) ? "click if you are no nore interested" : "click to express interest" 
    case what
    when Minisymposium, ConferenceSession, PosterSession
      link_to icon(now_icon), toggle_conference_session_interests_path(what), method: :post, title: title
    when Presentation
      link_to icon(now_icon), toggle_presentation_interests_path(what), method: :post, title: title 
    end
  end

  def owner_actions(what)
    return "&nbsp;".html_safe unless current_user_owns?(what)

    capture do 
      txt = (what.is_a?(Presentation) and what.authors.size > 1) ? ' edit or modify speaker' : ' edit'
      concat(link_to icon('pencil') + txt, [:edit, what])

      # plenary, minitutorial
      if what.respond_to?(:chairs) 
        concat(link_to icon('plus') + ' add chair', [:new, what, :organizer])
      elsif what.is_a?(Minisymposium)
        concat(link_to icon('plus') + ' add organizer', [:new, what, :organizer])
      end 

      if what.respond_to?(:authors) 
        concat(link_to icon('plus') + ' add author', [:new, what.respond_to?(:presentation) ? what.presentation : what, :author])
      end 

      # unless Plenay / Minitutorial which has ONE presentation
      if what.respond_to?(:presentations) and ! what.respond_to?(:presentation)
        presentation_label = what.is_a?(PosterSession) ? 'poster' : 'presentation'
        concat(link_to icon('file-audio-o') + " add #{presentation_label}", [:new, what, :presentation])
        concat(link_to icon('list') + " manage #{presentation_label}s", manage_presentations_conference_session_path(what))
      end 

      concat(link_to_delete('delete', what))

      if conference_session = what.try(:conference_session)   
        concat(link_to icon('reply') + " back to #{I18n.t conference_session.class}", conference_session)
      end 
      "&nbsp;".html_safe
    end
  end

  def organizer_committee_actions(what)
    return "&nbsp;".html_safe unless user_in_organizer_committee?

    capture do 
      if what.is_a?(ConferenceSession)
        concat(link_to icon('clock-o') + ' schedule', new_conference_session_schedule_path(what))
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

  def scientific_committee_actions(what)
    capture do 
      if user_in_scientific_committee? and what.ratable? and ! what.accepted?
        concat(link_to icon('star') + ' rate', [:new, what, :rating], remote: true)
      end 

      "&nbsp;".html_safe
    end
  end
end

