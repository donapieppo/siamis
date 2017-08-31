module SiamHelper
  def bologna_welcome_links
    "for more information on Bologna please visit <br/><br/>".html_safe + 
    link_to(image_tag('bologna_welcome.png'), 'http://www.bolognawelcome.com/en') + 
    "<br/><br/>or download this guide in pdf <br/>".html_safe +
    link_to('- Bologna, Your Destination -', '/BolognaWelcome2017.pdf') 
  end
end
