class LatexController < ApplicationController
  before_action :user_in_organizer_committee!

  def index
  end

  def plenaries
    @plenaries = Plenary.includes(schedules: :room, presentation: [authors: :user], organizers: :user).order('schedules.start, users.surname').all
  end

  def minitutorials
    @minitutorials = Minitutorial.includes(schedules: :room, presentation: [authors: :user], organizers: :user).order('schedules.start, users.surname').all
  end

  def minisymposia
    @conference_sessions = Minisymposium.order(:number).includes(:presentations).limit(20)
  end

  def contributed
    @conference_sessions = ContributedSession.order(:number).includes(:presentations).limit(20)
    render action: :minisymposia
  end

  def posters
    @posters = PosterSession.order(:number).includes(:presentations).limit(20)
  end
end
