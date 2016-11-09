class SubmissionsController < ApplicationController
  def index
    @minisymposia  = current_user.minisymposia.all
    @presentations = current_user.presentations.all
  end
end
