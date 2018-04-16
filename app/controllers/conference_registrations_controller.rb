# current_user does not create here but after payment.
# organizing_commette creates here.
class ConferenceRegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: :new

  before_action :user_in_organizer_committee!, only: [:manual_new, :manual_create, :edit, :update] # remember index
  before_action :user_in_organizer_or_management_committee!, only: [:index, :recipe]

  def index
    @conference_registrations = ConferenceRegistration.includes(:user, :payment)
    if params[:by_name]
      @conference_registrations = @conference_registrations.order('users.surname, users.name')
    else
      @conference_registrations = @conference_registrations.order('updated_at DESC')
    end
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
    if user_in_organizer_or_management_committee? 
      @conference_registration = ConferenceRegistration.includes(:user).find(params[:id])
    else
      @conference_registration = current_user.conference_registration
    end

    @fields = User.all_fields
    @payment = @conference_registration ? @conference_registration.payment : nil

    respond_to do |format|
      format.html
      format.pdf do
        pdf = PrintableRegistration.new(@conference_registration)
        filename = "#{@conference_registration.user.name}_#{@conference_registration.user.surname}_registration.pdf".gsub(' ', '_')
        send_data pdf.render, filename: filename, type: "application/pdf"
      end
    end
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

  def recipe
    @conference_registration = ConferenceRegistration.includes(:user, :payment).find(params[:id])
    pdf = PrintableRecipe.new(@conference_registration)
    filename = "#{@conference_registration.user.name}_#{@conference_registration.user.surname}_recipe.pdf".gsub(' ', '_')
    send_data pdf.render, filename: filename, type: "application/pdf"
  end

  def expected
    @totals = Hash.new{|h, k| h[k] = { number: 0, users: [], total: 0 }}

    # expected partecipants: speakers and organizers
    Role.speakers_and_organizers.includes(:user).map(&:user).uniq.each do |user|
      if registration = user.conference_registration
        @totals[:speakers_organizers_already_registered][:number] += 1
        if registration.payment and registration.payment.verified
          # @totals[:registered][:users] << user.email
          @totals[:speakers_organizers_already_registered][:total] += user.conference_registration.payment.amount
        end
      else
        @totals[:speaker_organizers_still_not_registered][:number] += 1
        fee = Fee.new(user).expected_payment_from_speakers_and_organizers
        fee[1] or raise fee.inspect
        @totals[fee[1]][:number] += 1
        # @totals[fee[1]][:users] << user.email
        @totals[fee[1]][:total] += fee[0]
      end
    end
  end
end

