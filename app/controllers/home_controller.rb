class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @home_header   = true
    @plenaries     = Plenary.includes(presentation: [authors: :user], schedule: :room).order('users.surname, users.name')
    @minitutorials = Minitutorial.includes(presentation: [authors: :user], schedule: :room).order('users.surname, users.name')
  end

  def contacts
  end

  def venue
  end

  def privacy
  end

  def participants
    @participants = User.partecipants.order('surname, name')
  end
end
