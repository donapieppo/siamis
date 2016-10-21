class RegistrationsController < ApplicationController
  before_action :force_sso_user

  def new
    @me  = current_user
    @fee = Fee.new(@me)
    @price_to_pay_and_reason = @fee.price_to_pay_and_reason
  end

  def show
    @registrtion = current_user.registration
    @payment = @registration.payment
  end

  def check
    raise "OK"
  end
end

