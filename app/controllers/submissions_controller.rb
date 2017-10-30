class SubmissionsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :user_in_organizer_or_scientific_committee!, except: [:index]

  # all minisymposia
  # presentations only unaccepted
  def index
    if current_user
      @presentations = current_user.presentations.includes(:conference_session, authors: :user)
      @minisymposia  = current_user.minisymposia.includes(organizers: :user)
    end
  end

  def admin
    if @position = params[:minisymposium]
      @list = Minisymposium.left_outer_joins(:presentations)
                                   .select('conference_sessions.*, COUNT(presentations.id) AS presentation_count')
                                   .group('presentations.conference_session_id')
                                   .includes(ratings: :user, organizers: :user)
      if user_in_organizer_committee?
        @list = @list.order('updated_at DESC')
      else
        @list = @list.order('name')
      end
      @my_ratings = current_user.ratings.select(:conference_session_id).pluck(:conference_session_id)

      if params[:tag_id]
        @tag = Tag.find(params[:tag_id]) 
        @list = @list.left_outer_joins(:tags).where('tags.id = ?', @tag.id)
      end
    elsif @position = params[:contributed]
      @list = Presentation.includes(:conference_session, ratings: :user, authors: :user)
                          .unassigned
                          .not_poster 
      @my_ratings = current_user.ratings.select(:presentation_id).pluck(:presentation_id)
    else
      @position = params[:poster] || 0
      @list = Presentation.includes(:conference_session, ratings: :user, authors: :user)
                          .unassigned
                          .poster 
      @my_ratings = current_user.ratings.select(:presentation_id).pluck(:presentation_id)
    end
  end
end
