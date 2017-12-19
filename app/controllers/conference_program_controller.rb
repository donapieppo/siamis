class ConferenceProgramController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if user_in_organizer_or_scientific_committee?
      # always 
      @daynumber = params[:day]
      @day = Schedule.conference_day(@daynumber)
      @room = Room.find(params[:room_id]) if params[:room_id]
      @conference_program = Schedule.day_program(@day, @room)
    end
  end

  def index2
    if user_in_organizer_or_scientific_committee?
      # always 
      @day = Schedule.conference_day(params[:day])
      @conference_program = Schedule.day_program(@day)
    end
  end
end


