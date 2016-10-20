class MinitutorialsController < ApplicationController
  before_action :force_sso_user, except: :index
  before_action :set_minitutorial_and_check_permission, only: [:edit, :update]

  def index
  end

  def show
    @minitutorial = Minitutorial.find(params[:id])
  end

  def new
    @minitutorial = Minitutorial.new
  end

  def create 
    @minitutorial = Minitutorial.new(minitutorial_params)
    if @minitutorial.save 
      @minitutorial.organizers.create!(user: current_user)
      redirect_to @minitutorial, notice: 'The minitutorial has been created.'
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @minitutorial.update_attributes(minitutorial_params)
      redirect_to @minitutorial, notice: 'The minitutorial has been updated.'
    else
      render action: :edit
    end
  end

  private

  def minitutorial_params
    params[:minitutorial].permit(:name, :description)
  end

  def set_minitutorial_and_check_permission
    @minitutorial = Minitutorial.find(params[:id])
    current_user.owns!(@minitutorial)
  end
end


