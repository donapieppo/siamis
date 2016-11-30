class SubmissionsController < ApplicationController
  before_action :user_in_organizer_commettee!, only: [:admin]

  def index
    @user_minisymposia  = current_user.minisymposia.all
    @user_presentations = current_user.presentations.all
  end

  def admin

  end
end
