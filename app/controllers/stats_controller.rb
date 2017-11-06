class StatsController < ApplicationController
  skip_before_action :authenticate_user!

  def countries
    @users      = User.order(:country).group(:country).count('users.id')
    @speakers   = Author.includes(:user).where('speak = 1').group('users.country').count('users.id')
    @organizers = Organizer.includes(:user).group('users.country').count('users.id')
  end
end

