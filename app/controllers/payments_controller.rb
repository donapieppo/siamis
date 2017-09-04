class PaymentsController < ApplicationController

  def new
    if current_user.payments.verified.any?
      redirect_to check_conference_registrations_path and return
    else
      @single_day = params[:single_day]
      @fee = Fee.new(current_user, single_day: @single_day)
      @price_to_pay_and_reason = @fee.price_to_pay_and_reason
    end
  end

  # params[:payment][:single_day] is the number of day (from 0)
  # crea un payment (ovvero si collega con unicredit e prepara un a richiesta. se accettata redirige l'utente al pagamento
  # di questa richiesta altrimenti mostra l'errore
  def create
    @conference_day = nil
    if params[:payment] and params[:payment][:single_day]
      @conference_day = Schedule.conference_day(params[:payment][:single_day].to_i)
    end
    @fee = Fee.new(current_user, single_day: @conference_day)

    @payment = current_user.payments.new(amount: @fee.price_to_pay, single_day: @conference_day)
    @payment.save
    if @payment.error_code
      render :error
    else
      redirect_to @payment.redirect_url
    end
  end

  # redirected by Unicredit
  # :NotifyURL=>"/payments/3/verify"
  def verify
    @payment = Payment.find(params[:id])
    unless @payment.verified 
      if ! @payment.verify
        render :error
        return 
      end
    end
  end

  # used by unicredit in case of error
  # :ErrorURL=>"/payments/3/error"
  def error
    @payment = Payment.find_by_id(params[:id])
    @rc = params[:rc] || 'Unknown error'
  end

end

