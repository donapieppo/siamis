class RatingsController < ApplicationController
  before_action :user_committee_organizer!
  before_action :set_minisymosium_and_minitutorial_and_presentation

  def index
    @ratings = @what.ratings.includes(:user, :minitutorial, :minisymposium, :presentation).all
  end

  def new
    @rating = @what.ratings.new
  end

  def create
    @rating = @what.ratings.new(rating_params)
    @rating.user = current_user
    if @rating.save
      redirect_to @what
    else
      render action: :new
    end
  end

  def destroy
    raise "TO IMPLEMENT"
  end

  private

  def rating_params
    params[:rating].permit(:score, :notes)
  end

end
