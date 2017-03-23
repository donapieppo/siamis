class ConferenceRegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: :new
  before_action :user_in_organizer_committee!, only: [:index]

  def index
    @conference_registrations = ConferenceRegistration.includes(:user, :payment)
    # volendo @payments = Payment.includes(:user)
  end

  def new
    if current_user 
      @fields = User.all_fields

      @fee = Fee.new(current_user)
      @price_to_pay_and_reason = @fee.price_to_pay_and_reason

      @single_day_fee = Fee.new(current_user, single_day: true)
      @single_day_price_to_pay_and_reason = @single_day_fee.price_to_pay_and_reason
    end
  end

  def show
    @fields = User.all_fields
    @conference_registration = current_user.conference_registration
    @payment = @conference_registration.payment
  end

  def check
    raise "OK"
  end
end

