class Commettee::ConferenceSessionsController < ApplicationController
  before_action :user_in_scientific_commettee!

  def index
    @minisymposia = Minisymposium.all
  end
end

