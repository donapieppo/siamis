class LatexController < ApplicationController

  def index
  end

  def plenaries
    @plenaries = Plenary.includes(schedules: :room, presentation: [authors: :user], organizers: :user).order('schedules.start, users.surname').all
  end

  def minitutorials
    @minitutorials = Minitutorial.includes(schedules: :room, presentation: [authors: :user], organizers: :user).order('schedules.start, users.surname').all
  end

  def minisymposia
    @minisymposia = Minisymposium.order(:number).includes(:presentations).limit(20)
  end

end
