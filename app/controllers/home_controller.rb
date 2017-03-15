class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @home_header    = true
  end

  def contacts
  end

  def venue
  end

  def privacy
  end

  def partecipants
    @partecipants = User.all
  end
end
