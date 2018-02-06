class HotelsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  before_action :user_in_organizer_committee!, except: :index
  before_action :set_hotel, only: [:edit, :update, :destroy]

  def index
    @no_container = true
  end

  def new
    @hotel = Hotel.new
  end

  def create
    @hotel = Hotel.new(hotel_params)
    if @hotel.save
      redirect_to hotels_path, notice: 'OK'
    else
      render action: :new
    end
  end

  def update
    if @hotel.update_attributes(hotel_params)
      redirect_to hotels_path, notice: 'OK'
    else
      render action: :edit
    end
  end

  private 

  def hotel_params
    params[:hotel].permit(:name, :description, :address, 
                          :singleprice, :singleprice_deluxe, 
                          :dusprice, :dusprice_deluxe, 
                          :doubleprice, :doubleprice_deluxe, 
                          :suiteprice, :juniorsuiteprice, :apartment, 
                          :bb, :tax, :web_page, :booking_page, :image, :lat, :lng)
  end

  def set_hotel
    @hotel = Hotel.find(params[:id])
  end
end
