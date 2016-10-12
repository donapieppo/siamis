class OrganizersController < ApplicationController
  before_action :force_sso_user
  before_action :set_minisymosium_and_minitutorial, only: [:new, :create]

  def new
    @organizer = Organizer.new
  end

  def create
    @organizer = Organizer.new(organizer_params)
    
    if @organizer.save
      redirect_to [:edit, @minitutorial || @minisymposium], notice: 'OK'
    else
      render action: :new
    end
  end

  private 

  def organizer_params
    params[:organizer][:minisymposium_id] = @minisymposium.id if @minisymposium
    params[:organizer][:minitutorial_id]  = @minitutorial.id if @minitutorial
    params[:organizer].permit(:email, :name, :surname, :affiliation, :address, :minisymposium_id, :minitutorial_id)
  end

  def set_minisymosium_and_minitutorial
    @minisymposium = Minisymposium.find(params[:minisymposium_id]) if params[:minisymposium_id]
    @minitutorial = Minitutorial.find(params[:minitutorial_id]) if params[:minitutorial_id]
  end
end

