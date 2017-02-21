class ConferenceRegistrationsController < ApplicationController
  before_action :user_in_organizer_commettee!, only: [:index]

  def index
    @conference_registrations = ConferenceRegistration.includes(:user, :payment)
    # volendo @payments = Payment.includes(:user)
  end

  def new
    @fields = User.all_fields

    @fee = Fee.new(current_user)
    @price_to_pay_and_reason = @fee.price_to_pay_and_reason

    @single_day_fee = Fee.new(current_user, single_day: true)
    @single_day_price_to_pay_and_reason = @single_day_fee.price_to_pay_and_reason
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

