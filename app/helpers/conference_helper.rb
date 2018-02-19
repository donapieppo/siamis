module ConferenceHelper

  def user_modal_link(user)
    return "" unless user
    cn = (current_user == user) ? "<u>#{h user.cn.upcase}</u>".html_safe : user.cn
    link_to h(cn), user_path(user), remote: true 
  end

  def show_registered(user)
    if user_in_organizer_or_management_committee? && user.conference_registration 
      " <span style='color: green; font-weight: bold'>&euro;</span> ".html_safe 
    else 
      ""
    end
  end

  def show_role(role, editable: false, no_affiliation: false)
    return '' unless role
    user = role.user
    user_modal_link(user) + 
    show_registered(user) +
    (no_affiliation ? "" : " (<small> #{h(user.affiliation)} </small>) ".html_safe) +
    (editable ? link_to_delete(role) : "")
  end

  # html_safe becouse of h() before
  def show_roles(roles, editable: false, only_speaker: false)
    if only_speaker 
      roles = roles.select{|r| r.speak}
    end
    roles.map do |role|
      show_role(role, editable: editable)
    end.join(', ').html_safe
  end

  def show_roles_list(roles)
    content_tag(:ul) do 
      roles.map do |role|
        concat content_tag(:li, show_role(role))
      end
    end
  end

  def rating_stars(rating)
    # can be nil if new rating
    return unless rating
    color = "red"   if rating < 3
    color = "green" if rating > 3
    (1..rating).map{|i| "<span style=\"color: #{color}\">★</span>"}.join.html_safe +
    (rating..4).map{|i| "<span>☆</span>"}.join.html_safe
  end

  def conference_session_parent_list_link(conference_session)
    name = I18n.t(conference_session.class.to_s.pluralize)
    link_to name, Rails.application.routes.path_for(controller: conference_session.class.to_s.pluralize.tableize, action: :index)
  end

  def breadcrumbs_minimal
    @conference_session or @presentation or return ''

    content_tag 'ol', class: "breadcrumb" do 
      content_tag('li', link_to('Home', root_path)) +
      if @conference_session
        content_tag('li', conference_session_parent_list_link(@conference_session)) +
        (@conference_session.new_record? ? '' : content_tag('li', link_to(@conference_session, @conference_session)))
      elsif @presentation and @presentation.conference_session
        content_tag('li', conference_session_parent_list_link(@presentation.conference_session)) +
        content_tag('li', link_to(@presentation.conference_session, @presentation.conference_session))
      end 
    end
  end

  def breadcrumbs
    controller.class.to_s =~ /Devise/ and return 
    controller.controller_name == 'registrations' and return 
    controller.controller_name == 'passwords' and return 
    controller.controller_name == 'stats' and return 
    content_tag 'ol', class: "breadcrumb" do 
      content_tag('li', link_to('Home', root_path)) +
      if @conference_session
        content_tag('li', conference_session_parent_list_link(@conference_session)) +
        (@conference_session.new_record? ? '' : content_tag('li', link_to(@conference_session, @conference_session)))
      elsif @presentation and @presentation.conference_session
        content_tag('li', conference_session_parent_list_link(@presentation.conference_session)) +
        content_tag('li', link_to(@presentation.conference_session, @presentation.conference_session))
      elsif controller.controller_name == 'impersonations' or controller.controller_name == 'users'
        content_tag('li', current_user ? current_user.cn : '')
      else
        unless controller.controller_name == 'home' 
          content_tag('li', link_to(I18n.t(controller.controller_name.camelize), controller: controller.controller_name, action: :index))
        end
      end 
    end
  end

  def program_title(what, icon = nil)
    content_tag :div, class: 'centered' do
    content_tag :h1, class: 'program' do
      icon(icon, size: 41) + "&nbsp;".html_safe + what 
    end
    end
  end

  def title_with_conference(what = '')
    content_tag(:h1) do 
      html_escape(what) + '<br/><small>SIAM-IS18 June 5-8, 2018 Bologna - Italy</small>'.html_safe
    end
  end

  def users_list(what)
    what.send(what.is_a?(Minisymposium) ? :organizers : :authors).includes(:user).order('users.surname').map {|author|
      h(author.user.cn) + " " + content_tag(:em, "(#{h(author.user.affiliation)})")
    }.join(', ').html_safe
  end

  def ul_users_list(what)
    content_tag(:ul) do
      what.send(what.is_a?(Minisymposium) ? :organizers : :authors).includes(:user).order('users.surname').each do |author|
        concat content_tag(:li, author.user.web_page ? link_to(author.user.to_s, author.user.web_page) : author.user.to_s)
      end
    end  
  end

  def next_to_rate(what)
    case what
    when Minisymposium
      Minisymposium.unrated.first
    when Presentation
      Presentation.unrated.first
    end
  end

  def link_to_next_approval(what)
    user_in_organizer_committee? or return ""
    content_tag(:p, class: 'centered') do
      what ? link_to('next', what, class: :button) : ''
    end
  end

  def link_to_next_rating(what)
    user_in_scientific_committee? or return ""
    content_tag(:p, class: 'centered') do
      what ? link_to('next to rate', what, class: :button) : 'You have rated all minisymposia'
    end
  end

  def show_schedule(what)
    res = "".html_safe
    case what
    when MultipleConferenceSession
      what.schedules.each do |s|
        res += content_tag(:div, s.to_s)
      end
    when MonoConferenceSession
      res = content_tag(:span, what.schedule || I18n.t(:schedule_to_be_decided), class: "pull-right")
    when Presentation
      res = content_tag(:span, what.schedule || I18n.t(:schedule_to_be_decided), class: "pull-right")
    end
    res
  end

  def user_roles(user)
    res = []
    user.authors.each do |author|
      res << "<strong>Author</strong> of the presentation <em>'#{h author.presentation.to_s}'</em>"
    end
    user.organizers.each do |organizer|
      res << "<strong>Organizer</strong> in the session <em>'#{h organizer.conference_session.to_s}'</em>"
    end
    res
  end

  # plenary_panel
  # minitutorial_panel
  def conference_session_panel_class(conference_session)
     conference_session.class.to_s.downcase + "_panel"
  end

  def list_presentations(presentations, conference_session)
    content_tag(:dl, class: "conference_session_presentations_list") do
      presentations.each do |presentation| 
        concat(content_tag(:dt, link_to(presentation, presentation, remote: true)))
        # for organizer_committee_or_cochair
        has_abstract_icon = (user_in_organizer_committee_or_cochair? and presentation.abstract and presentation.abstract.size >= 50) ? icon('font', size: "14") : ''
        concat(content_tag(:dd, show_roles(presentation.authors, only_speaker: true) + " " + has_abstract_icon))
      end
    end
  end

  def dl_presentations(presentations)
    content_tag(:dl, class: "dl-horizontal") do
      concat content_tag(:dt, "Presentations:") 
      presentations.each do |presentation| 
        concat(content_tag(:dd, link_to(presentation, presentation) + " <span class='pull-right'>#{show_role(presentation.speaker)}</span>".html_safe))
      end
      # bug butstrap dl-horizontal
      if presentations.empty?
        concat(content_tag(:dd, "&nbsp;".html_safe))
      end
    end
  end

  def conference_session_color(cs)
    case cs
    when Minisymposium
      'orange'
    when PosterSession
      'lightblue'
    when ContributedSession
      'lightgreen'
    when Plenary
      'yellow'
    end
  end

  def user_photo(user, small: false)
    if asset_exist?(user.photo_asset)  
      image_tag(user.photo_asset, width: (small ?  100 : 250), class: 'img-rounded')
    else
      '<i class="fa fa-user-circle" style="font-size: 80px; margin: 20px;" aria-hidden="true"></i>'.html_safe
    end
  end

  def mail_to_siam
    icon('envelope-o')+   mail_to(Rails.configuration.contact_mail, Rails.configuration.contact_mail_name)
  end

  def committe_name
    'Bologna Committee for IS Conference 2018 (BCIS18)'
  end

  def html_id(what)
    case what
    when ConferenceSession
      "html_cs_#{what.id}"
    else
      "html_id_#{what.id}"
    end
  end

  ROMAN_NUMBERS = ['I', 'II', 'III', 'IV', 'V']

  def show_parts_range(conference_session)
    (conference_session.parts < 1) and return ""
    'I - ' + ROMAN_NUMBERS[conference_session.parts - 1]
  end

  def schedules_list(schedules)
    return '' unless schedules
    schedules = [schedules] if schedules.is_a?(Schedule)
    content_tag(:ul) do 
      schedules.each do |s|
        concat content_tag(:li, s, class: 'small')
      end
    end
  end
end

