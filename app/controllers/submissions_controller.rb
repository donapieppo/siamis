class SubmissionsController < ApplicationController
  def index
    if current_user
      @minisymposia  = current_user.minisymposia
      @presentations = current_user.presentations
    end
  end
end
