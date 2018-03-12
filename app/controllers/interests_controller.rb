class InterestsController < ApplicationController
  before_action :set_what_and_part, except: :index

  # interests are not schedules but conference_sessions. 
  def index
    @interests = Hash.new {|hash, key| hash[key] = []}
    current_user.interests.includes(presentation: :conference_session, conference_session: :schedules).order('schedules.start').map do |interest|
      @interests[interest.start.to_date] << { start: interest.start, part: interest.part, cs: interest.conference_session }
    end
    Plenary.find_each do |cs|
      @interests[cs.schedules.first.start.to_date] << { start: cs.schedules.first.start,  part: 1, cs: cs }
    end
  end

  def session_ids
    @interests = current_user.interests.where('conference_session_id is not null').to_a
    render json: { head: :ok, interests: @interests }
  end

  def toggle
    @actual = Interest.modify!(current_user, @what, @part)
  end

  private

  def set_what_and_part
    @what = ConferenceSession.find(params[:conference_session_id]) if params[:conference_session_id]
    @what = Presentation.find(params[:presentation_id]) if params[:presentation_id]
    @part = params[:part]
  end
end

