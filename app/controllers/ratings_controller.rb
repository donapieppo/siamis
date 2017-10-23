class RatingsController < ApplicationController
  before_action :user_in_scientific_committee!
  before_action :set_what, except: :index

  def index
    # only cochairs and admins
    if user_in_organizer_committee_or_cochair?
      @ratings = Rating.includes(:minisymposium, :user).order(:conference_session_id)
    else
      redirect_to root_path, alert: "no access"
    end
  end

  def new
    @rating = @what.ratings.where(user: current_user).first || @what.ratings.new(user: current_user)
  end

  def update
    @rating = @what.ratings.where(user: current_user).first || @what.ratings.new(user: current_user)
    @rating.user = current_user
    if @rating.update_attributes(rating_params)
      what_type = case @what
                  when Minisymposium
                    'minisymposium'
                  when Presentation 
                    @what.poster ? 'poster' : 'presentation'
                  end

      redirect_to admin_submissions_path(what_type => @what.id)
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
