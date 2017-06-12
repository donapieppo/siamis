class InvitationLettersController < ApplicationController
  before_action :user_in_organizer_committee!, only: :index

  def index
    @invitation_letters = InvitationLetter.includes(:user)

  end

  def new
    @invitation_letter = current_user.invitation_letter || current_user.build_invitation_letter
  end

  def create
    @invitation_letter = current_user.build_invitation_letter(invitation_letter_params)
    if @invitation_letter.save
      redirect_to visa_path, notice: "Your request has been recorded."
    else
      render :new
    end
  end

  def edit
    @invitation_letter = current_user.invitation_letter
  end

  def update
    @invitation_letter = current_user.invitation_letter
    if @invitation_letter.update_attributes(invitation_letter_params)
      redirect_to visa_path, notice: "Your request has been recorded."
    else
      render :edit
    end
  end

  private

  def invitation_letter_params
    params[:invitation_letter].permit(:passport_name, :birthdate, :passport_origin, :passport_number,
                                      :address, :city, :state, :zip, :country)
  end
end
