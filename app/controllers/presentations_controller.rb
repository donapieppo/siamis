class PresentationsController < ApplicationController
  before_action :force_sso_user
  before_action :set_minisymosium_and_minitutorial_and_check_permission, only: [:new, :create]
  before_action :set_presentation_and_check_permission, only: [:edit, :update]

  def show
    @presentation = Presentation.find(params[:id])
    @speakers = @presentation.speakers.includes(:user)
  end

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

  def edit
  end

  def update
    if @presentation.update_attributes(presentation_params)
      redirect_to @presentation, notice: 'OK'
    else
      render action: :edit
    end
  end

  private

  def presentation_params
    params[:presentation].permit(:name, :abstract)
  end

  def set_minisymosium_and_minitutorial_and_check_permission
    @minisymposium = Minisymposium.find(params[:minisymposium_id]) if params[:minisymposium_id]
    @minitutorial  = Minitutorial.find(params[:minitutorial_id]) if params[:minitutorial_id]
    current_user.owns!(@minisymposium || @minitutorial)
  end

  def set_presentation_and_check_permission
    @presentation = Presentation.find(params[:id])
    current_user.owns!(@presentation)
  end

end

