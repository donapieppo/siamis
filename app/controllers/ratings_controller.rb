class RatingsController < ApplicationController
  before_action :user_committee_organizer!
  before_action :set_minisymosium_and_minitutorial_and_presentation

  def index
    @ratings = @conference_session.ratings.includes(:user, :minitutorial, :minisymposium, :presentation).all
  end

  def new
    @rating = @conference_session.ratings.where(user: current_user).first || @conference_session.ratings.new(user: current_user)
  end

  def update
    @rating = @conference_session.ratings.where(user: current_user).first || @conference_session.ratings.new(user: current_user)
    @rating.user = current_user
    if @rating.update_attributes(rating_params)
      redirect_to @conference_session
    else
      render action: :new
    end
  end

  # only one 
  alias create update

  def destroy
    raise "TO IMPLEMENT"
  end

  private

  def rating_params
    params[:rating].permit(:score, :notes)
  end

end
