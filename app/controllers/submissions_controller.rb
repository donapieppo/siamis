class SubmissionsController < ApplicationController
  def index
    @minisymposia  = current_user.minisymposia
    @presentations = current_user.presentations
  end
end
