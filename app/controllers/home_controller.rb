class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @home_header   = @no_container = true
    @plenaries     = Plenary.includes(presentation: [authors: :user], schedule: :room).order('users.surname, users.name')
    @minitutorials = Minitutorial.includes(presentation: [authors: :user], schedule: :room).order('users.surname, users.name')
  end

  def contacts
  end

  def venue
    @no_container = true
  end

  def privacy
  end

  def participants
    @participants = User.partecipants.order('surname, name')
  end

  def travel_awards
  end

  def satellites
  end

  def credits
  end

  def prize
  end

  def child_care
  end

  def visa
  end
end
