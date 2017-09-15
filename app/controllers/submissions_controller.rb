class SubmissionsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :user_in_organizer_committee!, except: [:index]

  # all minisymposia
  # presentations only unaccepted
  def index
    if current_user
      @presentations = current_user.presentations.includes(:conference_session, authors: :user)
      @minisymposia  = current_user.minisymposia.includes(organizers: :user)
    end
  end

  def admin
    if params[:minisymposium]
      @minisymposia  = Minisymposium.left_outer_joins(:presentations)
                                    .select('conference_sessions.*, COUNT(*) AS presentation_count')
                                    .group('presentations.conference_session_id')
                                    .includes(:schedule, ratings: :user, organizers: :user)
                                    .order('updated_at DESC')

      if params[:tag_id]
        @tag = Tag.find(params[:tag_id]) 
        @minisymposia = @minisymposia.joins(:tags).where('tags.id = ?', @tag.id)
      end
    elsif params[:contributed]
      @presentations  = Presentation.includes(:conference_session, ratings: :user, authors: :user)
                                    .unassigned
                                    .not_poster 
    elsif params[:poster] 
      @posters = Presentation.includes(:conference_session, ratings: :user, authors: :user)
                             .unassigned
                             .poster 
    end
  end
end
