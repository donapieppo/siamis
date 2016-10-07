module LinkHelper

  def link_to_back url
    link_to 'indietro', url
  end

  alias back_link_to :link_to_back

  def link_to_delete(name = "", url)
    link_to icon('trash-o') + " " + name, url, method: :delete, title: 'elimina', data: {confirm: 'Siete sicuri di voler cancellare?'} 
  end

  def link_to_download(url)
    link_to icon('download'), url
  end
  alias_method :download_link, :link_to_download

  def link_to_show(name = "", url)
    link_to icon('search') + " " + name, url, title: "Mostra dettagli"
  end

  def link_to_edit(name = "", url)
    link_to icon('pencil') + " " + name, url, title: "Inserisci/modifica dati"
  end

  def link_to_edit2(name = "", url)
    link_to icon('pencil') + "  " + name, url, class: :button
  end

  def link_to_new(name = "", url)
    link_to icon('plus-circle') + "  " + name, url, class: :button
  end

  # REMOTE
  def link_to_remote_edit(url)
    link_to icon('pencil'), url, title: 'Inserisci/modifica dati', data: { toggle: "modal", target: "#main-modal" }
  end

  def link_to_remote_new(name = "", url)
    link_to icon('plus-circle') + " " + name, url, class: :button, data: { toggle: "modal", target: "#main-modal" }
  end

  def support_mail
    mail = 'mail@example.com'
    "<a href='mailto: #{mail}'>#{mail}</a>".html_safe
  end

end
