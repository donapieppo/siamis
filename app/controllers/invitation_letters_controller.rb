class InvitationLettersController < ApplicationController
  before_action :user_in_organizer_committee!, only: [:index, :show, :mark_as_sent, :mark_as_unsent]
  before_action :set_invitation_letter, only: [:show, :mark_as_sent, :mark_as_unsent]

  def index
    @invitation_letters = InvitationLetter.includes(:user)
  end

  def show
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
    if @invitation_letter.update(invitation_letter_params)
      redirect_to visa_path, notice: "Your request has been recorded."
    else
      render :edit
    end
  end

  def mark_as_sent
    @invitation_letter.update_attribute(:complete, true)
    redirect_to invitation_letters_path
  end

  def mark_as_unsent
    @invitation_letter.update_attribute(:complete, false)
    redirect_to invitation_letters_path
  end

  private

  def invitation_letter_params
    params[:invitation_letter].permit(:passport_name, :birthdate, :passport_origin, :passport_number,
                                      :address, :city, :state, :zip, :country)
  end

  def set_invitation_letter
    @invitation_letter = InvitationLetter.includes(:user).find(params[:id])
  end
end
