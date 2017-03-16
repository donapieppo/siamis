class HotelsController < ApplicationController
  before_action :user_in_organizer_committee!, except: :index
  before_action :set_hotel, only: [:edit, :update, :destroy]

  def index
    @hotels = Hotel.all
  end

  def new
    @hotel = Hotel.new
  end

  def create
    @hotel = Hotel.new(hotel_params)
    if @hotel.save
      redirect_to venue_path, notice: 'OK'
    else
      render action: :new
    end
  end

  def update
    if @hotel.update_attributes(hotel_params)
      redirect_to venue_path, notice: 'OK'
    else
      render action: :edit
    end
  end

  private 

  def hotel_params
    params[:hotel].permit(:name, :description, :address, :singleprice, :dusprice, :doubleprice, :bb, :tax, :web_page, :image)
  end

  def set_hotel
    @hotel = Hotel.find(params[:id])
  end
end
