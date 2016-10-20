# Take a look at http://railscasts.com/episodes/241-simple-omniauth
# The main difference is that we mainly use shibboleth authentication.
#
# in routes we have
#   get 'auth/google_oauth2/callback', to: 'logins#google_oauth2'
#   get 'auth/shibboleth/callback',    to: 'logins#shibboleth'
#   get 'auth/developer/callback',     to: 'logins#developer'
#
# The application that uses dm_unibo_commmon can define two login_methods:
# login_method: :allow_if_email
#   means that only users already present in database can login
# login_method: :allow_and_create
#   means that any user that passes omniauth authentication can login
#   and is saved in database
#
# and in app/controllers/application_controller.rb can add
# before_filter :log_current_user, :force_sso_user
# or
# before_filter :log_current_user, :redirect_unsigned_user
#
# force_sso_user means that all the pages are protected
# redirect_unsigned_user means that unsigned user can still see something (to refactor)
#
# see lib/dm_unibo_common/controllers/helpers.rb for method definitions.
class LoginsController < ApplicationController
  # raise: false see http://api.rubyonrails.org/classes/ActiveSupport/Callbacks/ClassMethods.html#method-i-skip_callback
  skip_before_action :verify_authenticity_token, only: :developer
  skip_before_action :force_sso_user, :redirect_unsigned_user, :check_role, :retrive_authlevel, raise: false

  # env['omniauth.auth'].info = {email, name, last_name}
  def google_oauth2
    parse_google_omniauth
    allow_and_create
  end

  def facebook
    parse_facebook_omniauth
    allow_and_create
  end

  def developer
    Socket.gethostname == 'truffaut' or Socket.gethostname == 'casa' or raise "NOT IN TRUFFAUT"
    Rails.env.development? or raise "NOT IN DEVELOPMENT"
    request.remote_ip == '127.0.0.1' or request.remote_ip == '::1' or request.remote_ip =~ /^172\.17\.\d+\.\d+/  or raise "ONLY LOCAL OF DOCKER. YOU ARE #{request.remote_ip}"
    sign_in_and_redirect User.first
  end

  # example ["_shibsession_lauree", "_affcf2ffbe098d5a0928dc72cd9de489"]
  #         ["_lauree_session", "YU5RSTM2OXdYMkRyVjV0SXI1K3c3eDJJdjZQ..... "]
  def logout
    cookies.delete(Rails.configuration.session_options[:key].to_sym)
    session[:user_id] = nil
    logger.info("after logout we redirect to params[:return] = #{params[:return]}")
    redirect_to root_path 
  end

  # Not authorized but valid credentials
  def no_access
  end

  def pippo_show
    # raise request.env.inspect
  end

  def index
  end

  private 

  # omniauth.auth: #<OmniAuth::AuthHash credentials=#<OmniAuth::AuthHash expires=true expires_at=... token="..."> extra=#<OmniAuth::AuthHash id_info=#<OmniAuth::AuthHash at_hash="..." aud="..." azp="..." email="donapieppo@gmail.com" email_verified=true exp=1472639186 iat=1472635586 iss="accounts.google.com" sub="..."> id_token="..." raw_info=#<OmniAuth::AuthHash email="donapieppo@gmail.com" email_verified="true" family_name="Dona" gender="male" given_name="Pieppo" kind="plus#personOpenIdConnect" locale="it" name="Pieppo Dona" picture="..." profile="..." sub="...">> info=#<OmniAuth::AuthHash::InfoHash email="donapieppo@gmail.com" first_name="Pieppo" image="https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg" last_name="Dona" name="Pieppo Dona" urls=#<OmniAuth::AuthHash Google="https://plus.google.com/104065190780467868357">> provider="google_oauth2" uid="104065190780467868357">
  def parse_google_omniauth
    # logger.info("omniauth.auth: #{request.env['omniauth.auth'].inspect}")
    oinfo  = request.env['omniauth.auth'].info
    @email = oinfo.email
    @name  = oinfo.name
  end

  # omniauth.auth: #<OmniAuth::AuthHash credentials=#<OmniAuth::AuthHash expires=true expires_at=1480285227 token="EAAPuofO2BuIBAAY5TaFnQfTFZBLbRAoBl7ZCrq6WZBLkw3RC39LD6OJyvlxynFtzZCvjlGsIxfLjoryYnIgxb7X3CSyiBAUAHxV93QHCxi1KZA1Q48ejwQQmXAZCHDguP0o26dMEf96VzjAL9P4qgFNYAom367BhnOZAaJ1J1qEZAQZDZD"> extra=#<OmniAuth::AuthHash raw_info=#<OmniAuth::AuthHash email="donapieppo@yahoo.it" id="1816187078617148" name="Peter Climb">> info=#<OmniAuth::AuthHash::InfoHash email="donapieppo@yahoo.it" image="http://graph.facebook.com/v2.6/1816187078617148/picture" name="Peter Climb"> provider="facebook" uid="1816187078617148">
  def parse_facebook_omniauth
    oinfo  = request.env['omniauth.auth'].info
    @email = oinfo.email
    @name  = oinfo.name
  end

  def allow_and_create
    user = User.where(email: @email).first
    if ! user
      logger.info "Authentication: User #{@email} to be CREATED"
      user = User.create!(email: @email, name: @name)
    end
    logger.info "Authentication: allow_and_create as #{user.inspect}"
    sign_in_and_redirect user
  end
  alias_method :log_and_create, :allow_and_create # old syntax 

  def sign_in_and_redirect(user)
    session[:user_id] = user.id
    # redirect_to session[:original_request] || root_path
    redirect_to root_path
  end
end

