class LatexController < ApplicationController
  # before_action :user_in_organizer_committee!
  skip_before_action :authenticate_user!

  def index
  end

  def plenaries
    @plenaries = Plenary.includes(schedules: :room, presentation: [authors: :user], organizers: :user).order('schedules.start, users.surname').all
  end

  def minitutorials
    @minitutorials = Minitutorial.includes(schedules: :room, presentation: [authors: :user], organizers: :user).order('schedules.start, users.surname').all
  end

  def minisymposia
    @conference_sessions = Minisymposium.order(:number).includes(:presentations)
  end

  def contributed
    @conference_sessions = ContributedSession.order(:number).includes(:presentations)
    render action: :minisymposia
  end

  def posters
    @posters = PosterSession.order(:number).includes(:presentations)
  end

  def program
  end
end
