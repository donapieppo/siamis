module ConferenceHelper

  def user_modal_link(user)
    return "" unless user
    cn = (current_user == user) ? user.cn.upcase : user.cn
    link_to h(cn), user_path(user), remote: true 
  end

  def show_role(role, editable: false)
    return unless role
    raw user_modal_link(role.user) + 
        " (" + h(role.user.affiliation) + ") " +
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

  def title(what)
    content_tag(:div, class: 'title') do 
      content_tag(:span, class: what.class.to_s) do 
        I18n.t(what.class.to_s)
      end + what.to_s
    end
  end

  def organized_by(conference_session)
    organizers_string = conference_session.organizers.map(&:to_s).join(', ')
    organizers_string.blank? ? "" : "organized by #{organizers_string}"
  end

  def title_with_conference(what = '')
    content_tag(:h1) do 
      html_escape(what) + '<br/><small>Siam-is18 June 5-8, 2018 Bologna - Italy</small>'.html_safe
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
    user_in_organizer_commettee? or return ""
    content_tag(:p, class: 'centered') do
      what ? link_to('next', what, class: :button) : ''
    end
  end

  def link_to_next_rating(what)
    user_in_scientific_commettee? or return ""
    content_tag(:p, class: 'centered') do
      what ? link_to('next to rate', what, class: :button) : 'You have rated all minisymposia'
    end
  end


  def ul_list(what)
    content_tag(:ul, class: 'list-group') do
      what.each do |x|
        concat(content_tag(:li, class: 'list-group-item') { link_to(x, x) })
      end
    end
  end

  def schedule(what)
    "&nbsp;".html_safe +
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
end

