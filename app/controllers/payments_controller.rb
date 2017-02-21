class PaymentsController < ApplicationController

  def new
    if current_user.payments.verified.any?
      redirect_to check_registrations_path and return
    else
      @single_day = params[:single_day]
      @fee = Fee.new(current_user, single_day: @single_day)
      @price_to_pay_and_reason = @fee.price_to_pay_and_reason
    end
  end

  # params[:payment][:single_day] is the number of day (from 0)
  def create
    conference_day = params[:payment][:single_day] ? Schedule.conference_day(params[:payment][:single_day].to_i) : nil
    @fee = Fee.new(current_user, single_day: conference_day)
    @payment = current_user.payments.create(amount: @fee.price_to_pay, single_day: conference_day)
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

