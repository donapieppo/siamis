module MenuHelper

  def login_link
    link_to 'sign-in / register', login_path
  end

  def logout_link
    link_to icon('sign-out'), logout_path, title: 'sign-out'
  end

  def logged_user
    if current_user
      content_tag(:li, class: 'login-name navbar-text') do
        current_user.name 
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

