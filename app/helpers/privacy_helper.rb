module PrivacyHelper 
  def privacy_cookie_name
    (Rails.configuration.session_options[:key] + "_privacy").to_sym
  end

  def privacy_alert
    name = privacy_cookie_name
    if cookies[name] 
      return ""
    else
      cookies[name] = { value: "accepted", expires: 1.year.from_now }
      raw %Q|<div class="alert alert-warning alert-dismissible" role="alert">
           <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times; chiudi</span></button> Questo sito web utilizza cookie analitici di terze parti. Utilizzando il sito si intende accettata la Cookie Policy.</div>|
    end
  end
end
