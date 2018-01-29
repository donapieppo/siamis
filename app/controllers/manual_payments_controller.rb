class ManualPaymentsController < ApplicationController
  before_action :user_in_organizer_committee!, except: [:index]
  before_action :user_in_organizer_or_management_committee!, only: [:index]

  def new
    @user = User.find(params[:user_id])
    @conference_registration = @user.conference_registration
    @manual_payment = @user.manual_payments.new
  end

  def create
    @user = User.find(params[:user_id])
    @conference_registration = @user.conference_registration || @user.conference_registration.new
    @manual_payment = @user.manual_payments.new(amount: params[:manual_payment][:amount], manual: 1, verified: 1)

    if @manual_payment.save
      if params[:for_registration]
        @conference_registration = @user.conference_registration || @user.conference_registration.new
        if ! @conference_registration.payment_id
          @conference_registration.payment_id = @manual_payment.id
          @conference_registration.save!
        end
      end
      redirect_to payments_path
    else
      render action: :new
    end
  end

end

