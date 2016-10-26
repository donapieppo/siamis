class RoomsController < ApplicationController
  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to root_path, notice: 'OK'
    else
      render action: :new
    end
  end

  private

  def room_params
    params[:room].permit(:name, :capacity, :building_id)
  end
end
