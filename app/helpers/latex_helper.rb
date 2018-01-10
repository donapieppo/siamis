module LatexHelper

  def latex_text_clean(txt)
    txt.chomp.gsub(/^\s*$[\r\n]+/, '').gsub('_', '\_').gsub('&') {'\\&'}
  end

end

