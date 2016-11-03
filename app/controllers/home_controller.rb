class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @home_header    = true
  end

end
