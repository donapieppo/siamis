class SearchController < ApplicationController
  
  def search
    @search_string = params[:search_string]

    if @search_string.size > 2 
      @users = User.where('name like ? OR surname like ?', "%#{@search_string}%", "%#{@search_string}%").all
      @conference_sessions = ConferenceSession.where('name like ?', "%#{@search_string}%").all
      @presentations = Presentation.where('name like ?', "%#{@search_string}%").all
      @tags = Tag.where('name like ?', "%#{@search_string}%").all
    else
      redirect_to root_path, alert: "Search string too short. Please refine your search criteria."
    end
  end

end

