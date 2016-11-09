class Admin::ConferenceSessionsController < ApplicationController
  before_action :user_committee_organizer!

  def index
    @minisymposia = Minisymposium.all
  end
end

