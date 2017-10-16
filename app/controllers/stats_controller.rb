class StatsController < ApplicationController
  before_action :user_in_organizer_committee_or_cochair!

  def countries
    @users = User.order(:country).group(:country).count(:country)
  end
end

