class HomeController < ApplicationController
  skip_before_action :force_sso_user

  def index
    @home_header    = true
  end

end
