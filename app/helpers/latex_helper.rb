module LatexHelper

  def latex_text_clean(txt)
    txt or return ''
    txt.chomp.gsub(/^\s*$[\r\n]+/, '').gsub('_', '\_').gsub('&') {'\\&'}.gsub('%', '\%')
  end

  def latex_url_clean(txt)
    txt.html_safe.gsub('_', '\_').gsub('%20', '\ ').gsub('#', '\#')
  end

  def latex_user(user, speak = nil)
    cn = latex_text_clean user.cn
    affiliation = latex_text_clean user.affiliation
    
    unless user.web_page.blank?
      cn = "{\\href{#{latex_url_clean(user.web_page)}}{#{cn}}}"
    end

    affiliation = " - " if affiliation.blank?

    # no more with bullet
    # "\\siamuser{#{'* ' if speak} #{cn}}{#{affiliation}}".html_safe
    "\\#{speak ? "siamspeaker" : "siamuser"}{#{cn}}{#{affiliation}}".html_safe
  end

end

