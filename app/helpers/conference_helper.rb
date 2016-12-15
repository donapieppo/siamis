module ConferenceHelper

  def user_modal_link(user)
    return "" unless user
    cn = (current_user == user) ? user.cn.upcase : user.cn
    link_to cn, user_path(user), remote: true 
  end

  def show_user(user)
    return unless user
    user_modal_link(user) + " (" + user.affiliation + ")"
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
    what.send(what.is_a?(Minisymposium) ? :organizers : :authors).map(&:to_s).join(', ')
  end

  def ul_users_list(what)
    content_tag(:ul) do
      what.send(what.is_a?(Minisymposium) ? :organizers : :authors).each do |author|
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

  def link_to_next_rating(what)
    user_in_scientific_commettee? or return ""
    content_tag(:p, class: 'centered') do
      what ? link_to('next to rate', what, class: :button) : 'You have rated all minisymposia'
    end
  end

end

