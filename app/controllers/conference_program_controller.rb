class ConferenceProgramController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @daynumber = params[:day] ? params[:day].to_i : 0
    @day = Schedule.conference_day(@daynumber)
    @room = Room.find(params[:room_id]) if params[:room_id]

    @user = params[:u] ? current_user : nil
    # update for user and for changes
    #if @user or stale?(strong_etag: "123456_#{@day}_111")
      @conference_program = Schedule.day_program(@day, room: @room, user: @user, with_includes: false)
    #end
  end

  def print
    if current_user # user_in_organizer_or_scientific_committee?
      pdf = PrintableProgram.new()
      pdf.render_file('public/siamis18_a3_program.pdf')
      send_data pdf.render, filename: "program.pdf", type: "application/pdf"
    else
      redirect_to root_path
    end
  end
end


