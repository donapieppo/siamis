class BookingsController < ApplicationController
  def new
    @sightseeing = Sightseeing.find(params[:sightseeing_id])
    @booking = current_user.bookings.new(sightseeing: @sightseeing)
  end

  def create
    @sightseeing = Sightseeing.find(params[:sightseeing_id])
    @booking = current_user.bookings.new(sightseeing: @sightseeing, number: params[:booking][:number])
    if @booking.save
      redirect_to sightseeings_path, notice: "CREATED"
    else
      render action: :new
    end
  end
end

