module ApplicationHelper
  def user_signed_in?
    current_user
  end

  def mod_icon(name, text)
    "#{material_icon.send(name).css_class('left')} #{text}".html_safe
  end

  def icon(name, options = { text: "", size: "18" })
    raw "<i style=\"font-size: #{options[:size]}px\" class=\"fa fa-#{name}\"></i> #{options[:text]}"
    raw "<i class=\"material-icons\">#{name}</i>"
  end

  def fwicon(name, options = { text: "", size: "18" })
    raw "<i style=\"font-size: #{options[:size]}px\" class=\"fa fa-#{name} fa-fw\"></i> #{options[:text]}"
  end

  def big_icon(name, options = {})
    icon(name, options.update(size: 26))
  end

  def bootstrap_modal_div
    raw %Q|
<div id="main-modal" class="modal">
    <div class="modal-content">
      <h4 class="modal-title"></h4>
      <div class="modal-body">A bunch of text</div>
    </div>
    <div class="modal-footer">
      <a href="#!" class=" modal-action modal-close waves-effect waves-green btn-flat">OK</a>
    </div>
  </div>
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
    link_to user.cn, user_path(user), remote: true 
  end

  def show_user(user)
    user_modal_link(user) + " (" + user.affiliation + ")"
  end

  def rating_stars(rating)
    (1..rating).map{|i| "<span>★</span>"}.join.html_safe +
    (rating..4).map{|i| "<span>☆</span>"}.join.html_safe
  end

  def breadcrumbs
  end

  def title(what)
    content_tag(:div, class: 'row') do
      content_tag(:div, class: 'col s3') do 
        content_tag(:h1, class: what.class.to_s) do 
          I18n.t(what.class.to_s)
        end 
      end + 
      content_tag(:div, class: 'col s9') do
        content_tag(:h1, what.name)
      end
    end
  end
end
