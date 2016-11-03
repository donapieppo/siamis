module MenuHelper

  def login_link
    link_to 'sign-in / register', new_user_session_path
  end

  def logout_link
    link_to icon('sign-out'), destroy_user_session_path, title: 'sign-out'
  end

  def logged_user
    if current_user
      content_tag(:li, class: 'login-name') do
        link_to current_user.name, edit_user_path(current_user)
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

