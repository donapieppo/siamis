# current_user does not create here but after payment.
# organizing_commette creates here.
class ConferenceRegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: :new
  before_action :user_in_organizer_committee!, only: [:index, :manual_new, :manual_create]

  def index
    @conference_registrations = ConferenceRegistration.includes(:user, :payment).order('users.surname, users.name')
  end

  def new
    # if already registered
    if @current_user_conference_registration 
      redirect_to conference_registration_path(@current_user_conference_registration)
      return
    end
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
      @conference_registration = ConferenceRegistration.includes(:user).find(params[:id])
    else
      @conference_registration = current_user.conference_registration
    end

    @fields = User.all_fields
    @payment = @conference_registration ? @conference_registration.payment : nil
  end

  def check
    raise "OK"
  end

  def manual_new
    @user = User.find(params[:user_id])
  end

  def manual_create
    @user = User.find(params[:user_id])
    @user.create_conference_registration
    redirect_to users_path, notice: 'The registration has been recorded.'
  end

end

