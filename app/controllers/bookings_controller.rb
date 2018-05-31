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

  def destroy
    @booking = Booking.find(params[:id])
    if user_in_organizer_committee? or @booking.user_id == current_user.id
      @booking.destroy
    end
    redirect_to sightseeings_path
  end
end

