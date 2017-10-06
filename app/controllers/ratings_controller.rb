class RatingsController < ApplicationController
  before_action :user_in_scientific_committee!
  before_action :set_what, except: :index

  def new
    @rating = @what.ratings.where(user: current_user).first || @what.ratings.new(user: current_user)
  end

  def update
    @rating = @what.ratings.where(user: current_user).first || @what.ratings.new(user: current_user)
    @rating.user = current_user
    if @rating.update_attributes(rating_params)
      redirect_to admin_submissions_path(@what.class.name.underscore => @what.id)
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

  def set_what
    @what = params[:minisymposium_id] ? Minisymposium.find(params[:minisymposium_id]) : Presentation.find(params[:presentation_id])
  end

  def rating_params
    params[:rating].permit(:score, :notes)
  end

end
