class InterestsController < ApplicationController

  def index
    @interests = current_user.interests.includes(:presentation, conference_session: :schedule)
  end
end

