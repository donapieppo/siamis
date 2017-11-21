# current_user does not create here but after payment.
# organizing_commette creates here.
class ConferenceRegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: :new

  before_action :user_in_organizer_committee!, only: [:manual_new, :manual_create] # remember index
  before_action :user_in_organizer_or_management_committee!, only: [:print]

  def index
    (user_in_organizer_committee? or user_in_management_committee?) or raise NoAccess
    @conference_registrations = ConferenceRegistration.includes(:user, :payment).order('updated_at DESC')
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
        filename = "#{@conference_registration.user.name} #{@conference_registration.user.surname} registration.pdf".gsub(' ', '_')
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

  def print
    #@conference_registrations = ConferenceRegistration.includes(:user, :payment).find(params[:id])
  end

  def expected
    @totals = Hash.new{|h, k| h[k] = { number: 0, users: [], total: 0 }}

    # expected partecipants: speakers and organizers
    Role.where('(type = "Author" and speak=1) or type="Organizer"').includes(:user).map(&:user).uniq.each do |user|
      # only speakers and organizers

      # already registerd
      if user.conference_registration and user.conference_registration.payment and user.conference_registration.payment.verified
        @totals[:already_registered][:number] += 1
        # @totals[:registered][:users] << user.email
        @totals[:already_registered][:total] += user.conference_registration.payment.amount
      else
        fee = Fee.new(user).expected_payment_from_speakers_and_organizers
        fee[1] or raise fee.inspect
        @totals[fee[1]][:number] += 1
        # @totals[fee[1]][:users] << user.email
        @totals[fee[1]][:total] += fee[0]
      end
    end
  end
end

