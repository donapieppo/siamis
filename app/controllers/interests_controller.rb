class InterestsController < ApplicationController
  before_action :set_what, except: :index

  # hash of days
  def index
    @interests = Hash.new{|h, k| h[k] = []}
    current_user.interests.includes(presentation: :conference_session, conference_session: :schedules).order('schedules.start').each do |interest|
      @interests[interest.on.schedule] << interest.on
    end
  end

  def toggle
    actual = Interest.modify!(current_user, @what)
    redirect_to @what, notice: (actual ? "You are interested to attend the session." : "You are no more interested to attend the session.")
  end

  private

  def set_what
    @what = ConferenceSession.find(params[:conference_session_id]) if params[:conference_session_id]
    @what = Presentation.find(params[:presentation_id]) if params[:presentation_id]
  end
end

