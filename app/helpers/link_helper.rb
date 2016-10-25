module LinkHelper

  def link_to_back url
    link_to 'indietro', url
  end

  alias back_link_to :link_to_back

  def link_to_delete(name = "", url)
    link_to icon('trash') + " " + name, url, method: :delete, title: 'delete', data: {confirm: 'Are you sure?'} 
  end

  def link_to_download(url)
    link_to icon('download'), url
  end
  alias_method :download_link, :link_to_download

  def link_to_show(name = "", url)
    link_to icon('search') + " " + name, url, title: "Show details"
  end

  def link_to_edit(name = "", url)
    link_to icon('pencil') + " " + name, url, title: "Modify", class: :button
  end

  def link_to_edit2(name = "", url)
    link_to icon('pencil') + "  " + name, url, class: :button
  end

  def link_to_new(name = "", url)
    link_to icon('plus-circle') + "  " + name, url, class: :button
  end

  # REMOTE
  def link_to_remote_edit(url)
    link_to icon('pencil'), url, title: 'Modify', data: { toggle: "modal", target: "#main-modal" }
  end

  def link_to_remote_new(name = "", url)
    link_to icon('plus-circle') + " " + name, url, class: :button, data: { toggle: "modal", target: "#main-modal" }
  end

  def support_mail
    mail = 'mail@example.com'
    "<a href='mailto: #{mail}'>#{mail}</a>".html_safe
  end

end
