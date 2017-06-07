module MenuHelper

  def login_link(button: false)
    link_to 'Sign-in / Register', new_user_session_path, class: button ? 'button' : ''
  end

  def logout_link
    link_to icon('sign-out'), destroy_user_session_path, title: 'sign-out', method: :delete
  end

  def menu_link(icon, name, url, general = nil)
    cssclass = (@home_header and general) ? "scrollto" : ''
    content_tag :li do
      link_to fwicon(icon) + ' ' + name, url, class: cssclass
    end
  end

  def logged_user
    if current_user
      content_tag(:li, class: 'login-name') do
        link_to current_user.cn, @conference_registration ? conference_registration_path(@conference_registration) :edit_user_path(current_user)
      end + 
      content_tag(:li, class: 'logout_link') do 
        logout_link
      end
    else
      content_tag :li do
        login_link
      end
    end
  end

  def dropdown_menu(title, &block)
    raw %Q|<li class="dropdown">
      <a href="#" class="dropdown-toggle" data-toggle="dropdown">#{title} <b class="caret"></b></a>
      <ul class="dropdown-menu">| + 
      capture(&block) + %Q|
      </ul>
      </li>|
  end

end

