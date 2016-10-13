class PresentationsController < ApplicationController
  before_action :force_sso_user
  before_action :set_minisymosium_and_minitutorial

  def new
    @presentation = Presentation.new
  end

  def create
    @presentation = (@minisymposium || @minitutorial).presentations.new(presentation_params)
    if @presentation.save
      redirect_to new_presentation_speaker_path(@presentation)
    else
      render action: :new
    end
  end

  private

  def presentation_params
    params[:presentation].permit(:name, :abstract)
  end

  def set_minisymosium_and_minitutorial
    @minisymposium = Minisymposium.find(params[:minisymposium_id]) if params[:minisymposium_id]
    @minitutorial  = Minitutorial.find(params[:minitutorial_id]) if params[:minitutorial_id]
  end
end

