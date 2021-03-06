class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @plenaries     = ConferenceSession.plenary_or_panel.includes(presentations: [authors: :user], schedules: :room).order('schedules.start, users.surname, users.name')
    @minitutorials = Minitutorial.includes(presentation: [authors: :user], schedules: :room).order('schedules.start, users.surname, users.name')
  end

  def contacts
  end

  def venue
  end

  def privacy
  end

  def participants
    @participants = User.visible_participants.order('surname, name')
    @link_to_user  = current_user
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
    @invitation_letter = current_user ? current_user.invitation_letter : nil
  end

  def equipments
  end
end
