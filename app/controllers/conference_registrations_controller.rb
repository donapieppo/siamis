class ConferenceRegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: :new
  before_action :user_in_organizer_committee!, only: [:index]

  def index
    @conference_registrations = ConferenceRegistration.includes(:user, :payment)
  end

  def new
    if @current_user_conference_registration 
      redirect_to conference_registration_path(@current_user_conference_registration)
      return
    end
    @no_container = true
    if current_user 
      @fields = User.all_fields

      @fee = Fee.new(current_user)
      @price_to_pay_and_reason = @fee.price_to_pay_and_reason

      @single_day_fee = Fee.new(current_user, single_day: true)
      @single_day_price_to_pay_and_reason = @single_day_fee.price_to_pay_and_reason
    end
  end

  def show
    if user_in_organizer_committee?
      @conference_registration = ConferenceRegistration.find(params[:id])
    else
      @conference_registration = current_user.conference_registration
    end

    @fields = User.all_fields
    @payment = @conference_registration ? @conference_registration.payment : nil
  end

  def check
    raise "OK"
  end
end

