class RoomsController < ApplicationController
  before_action :user_in_organizer_committee!, except: [:show]
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  def index
    @rooms = Room.includes(:building).order(:manual_order, :name)
  end

  def show
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to rooms_path, notice: 'The room has been created.'
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @room.update_attributes(room_params)
      redirect_to rooms_path, notice: 'The room has been updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @room.destroy
    redirect_to rooms_path
  end

  private

  def room_params
    params[:room].permit(:name, :capacity, :building_id, :floor, :manual_order)
  end

  def set_room
    @room = Room.find(params[:id])
  end
end

