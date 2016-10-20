class PaymentsController < ApplicationController

  def new
    if current_user.payments.verified.any?
      redirect_to check_registrations_path and return
    else
      @fee = Fee.new(current_user)
      @price_to_pay_and_reason = @fee.price_to_pay_and_reason
    end
  end

  def create
    @payment = current_user.payments.create
    @payment.start_pay
    redirect_to @payment.redirect_url
  end

  def verify
    @payment = Payment.find(params[:id])
    if ! @payment.verify
      raise NO
    end
  end

  def error
  end

end

