module SiamHelper
  def bologna_wecome_links
    "visit <br/>".html_safe + 
    link_to(image_tag('bologna_welcome.png'), 'http://www.bolognawelcome.com/en') + 
    "<br/>or download the guide in pdf <br/>".html_safe +
    link_to('Bologna, Your Destination', '/BolognaWelcome2017.pdf') 
  end
end
