class StatsController < ApplicationController
  # before_action :user_in_organizer_committee_or_cochair!

  def countries
    @users      = User.order(:country).group(:country).count('users.id')
    @speakers   = Author.includes(:user).where('speak = 1').group('users.country').count('users.id')
    @organizers = Organizer.includes(:user).group('users.country').count('users.id')
  end
end

