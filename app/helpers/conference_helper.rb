module ConferenceHelper

  def user_modal_link(user)
    return "" unless user
    cn = (current_user == user) ? user.cn.upcase : user.cn
    link_to h(cn), user_path(user), remote: true 
  end

  def show_role(role, editable: false)
    return unless role
    user_modal_link(role.user) + 
    " (<small>".html_safe + h(role.user.affiliation) + "</small>) ".html_safe +
    (editable ? link_to_delete(role) : "")
  end

  # html_safe becouse of h() before
  def show_roles(roles, editable: false)
    roles.map do |role|
      show_role(role, editable: editable)
    end.join(', ').html_safe
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

  def breadcrumbs
    controller.class.to_s =~ /Devise/ and return 
    controller.controller_name == 'home' and return 
    controller.controller_name == 'users' and return 
    controller.controller_name == 'registrations' and return 
    controller.controller_name == 'passwords' and return 
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
        content_tag('li', link_to(I18n.t(controller.controller_name.camelize), controller: controller.controller_name, action: :index))
      end 
    end
  end

  def program_title(what, icon = nil)
    content_tag :h1, class: 'program' do
      icon(icon, size: 41) + "&nbsp;".html_safe + what 
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

  def schedule(what)
     content_tag(:span, what.schedule || 'schedule to be decided', class: "pull-right")
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

  def link_to_top
    content_tag :div, style: 'text-align: right; margin-right: 10px' do
      link_to icon('chevron-circle-up', size: '28'), '#top', class: 'link_to_top'
    end
  end

  # plenary_panel
  # minitutorial_panel
  def conference_session_panel_class(conference_session)
     conference_session.class.to_s.downcase + "_panel"
  end

  def dl_presentations(presentations)
    content_tag(:dl, class: "dl-horizontal") do
      concat content_tag(:dt, "Presentations:") 
      presentations.each do |presentation| 
        concat(content_tag(:dd, link_to(presentation, presentation) + " <span class='pull-right'>#{show_role(presentation.speaker)}</span>".html_safe))
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

end

