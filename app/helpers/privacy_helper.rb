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
      raw %Q|
      <div class="alert alert-warning alert-dismissible" role="alert">
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times; close</span>
        </button> 
        <div class="container">
          #{PRIVACY_TEXT}
        </div>
      </div>|
    end
  end
end


PRIVACY_TEXT=%q|
<p>A number of our pages use <strong>cookies</strong> to identify you when you sign-in to our site.</p>
<p>The cookie-related information is not used to identify you personally and the pattern data is fully under our control. These cookies are not used for any purpose other than those described here. <a href="http://www.unibo.it/en/university/privacy-policy-and-legal-notes/privacy-policy/general-information-on-the-processing-of-personal-data-in-the-university-portal-system-websites">Unibo policy</a></p>
<p>By continuing to browse the site, or by clicking on “close”, you consent to the use of cookies.</p>
|.html_safe


