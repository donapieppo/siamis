module ApplicationHelper
  def user_signed_in?
    current_user
  end

  def icon(name, options = { text: "", size: "18" })
    raw "<i style=\"font-size: #{options[:size]}px\" class=\"fa fa-#{name}\"></i> #{options[:text]}"
  end

  def fwicon(name, options = { text: "", size: "18" })
    raw "<i style=\"font-size: #{options[:size]}px\" class=\"fa fa-#{name} fa-fw\"></i> #{options[:text]}"
  end

  def big_icon(name, options = {})
    icon(name, options.update(size: 26))
  end

  def bootstrap_modal_div
    raw %Q|
      <div class="modal fade" id="main-modal" >
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              <h4 class="modal-title"></h4>
            </div>
            <div class="modal-body">
            </div>
          </div><!-- .modal-content -->
        </div><!-- .modal-dialog -->
      </div><!-- .modal -->
|
  end

  # from https://github.com/seyhunak/twitter-bootstrap-rails
  ALERT_TYPES = [:success, :info, :warning, :danger]
  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = type.to_sym
      type = :success if type.to_s == :notice.to_s
      type = :danger if type.to_s == :alert.to_s
      type = :danger if type.to_s == :error.to_s
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                           msg, :class => "alert fade in alert-#{type}")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  def tooltip(key)
    message = Tooltip.message(key)
    raw %$<h3 class="info"> $ + image_tag("info.png", :width => '15') + 
        %$ #{message[0]} <span>#{message[1]}</span></h3>$
  end

  def popover_help(title, content)
    raw %Q|<i class="fa fa-question-circle pull-right popover-help" data-placement="left" data-toggle="popover" title="#{title}" data-content="#{content}"></i>|
  end

  # dl_field(User.first, :name)
  # dl_field(:user_name, "Pietro)
  def dl_field(object, what)
    if object.is_a?(Symbol)
      content_tag(:dt, I18n.t(object).capitalize) + 
      content_tag(:dd, what)
    else
      val = object.send(what)
      val == false and val = "-"
      val == true  and val = icon('check')
      content_tag(:dt, I18n.t("activerecord.attributes.#{object.class.to_s.downcase}.#{what}").capitalize) + 
      content_tag(:dd, val) # what is a symbol
    end
  end

  def class_active(x,y)
    x == y ? 'class="active"'.html_safe : ''
  end

  def info_tag(&block)
    raw %Q|<p class="info">| + capture(&block) + %Q|</p>|
  end

  # IMPERSONATION
  def stop_impersonation_link
    if (current_user == true_user)
      "" 
    else
      "You (#{true_user.email}) are impersonating <strong>#{current_user.email}</strong><br/> #{link_to icon('reply') + " back to admin", stop_impersonating_path}"
    end
  end

  def start_impersonation_link
    if true_user_can_impersonate?
      link_to icon('user') + " impersona", who_impersonate_path
    end
  end

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
    (1..rating).map{|i| "<span>★</span>"}.join.html_safe +
    (rating..4).map{|i| "<span>☆</span>"}.join.html_safe
  end

  def conference_session_parent_list_link(conference_session)
    name = I18n.t(conference_session.class.to_s.pluralize)
    link_to name, Rails.application.routes.path_for(controller: conference_session.class.to_s.pluralize.tableize, action: :index)
  end

  def breadcrumbs
    controller.class.to_s =~ /Devise/ and return 
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
end
