class ConferenceRegistrationsController < ApplicationController
  def new
    @me  = current_user
    @fee = Fee.new(@me)
    @price_to_pay_and_reason = @fee.price_to_pay_and_reason
  end

  def show
    @conference_registration = current_user.conference_registration
    @payment = @conference_registration.payment
  end

  def check
    raise "OK"
  end
end

