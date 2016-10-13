class MinisymposiaController < ApplicationController
  before_action :force_sso_user
  before_action :set_minisymposium_and_check_permission, only: [:edit, :update]

  def index
  end

  def new
    @minisymposium = Minisymposium.new
  end

  def create 
    @minisymposium = Minisymposium.new(minisymposium_params)
    if @minisymposium.save 
      @minisymposium.organizers.create!(user_id: current_user.id)
      redirect_to edit_minisymposium_path(@minisymposium), notice: 'The minisymposium has been created.'
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @minisymposium.update_attributes(minisymposium_params)
      redirect_to [:edit, @minisymposium], notice: 'The minisymposium has been updated.'
    else
      render action: :edit
    end
  end

  private

  def minisymposium_params
    params[:minisymposium].permit(:name, :description)
  end

  def set_minisymposium_and_check_permission
    @minisymposium = Minisymposium.find(params[:id])
    current_user.owns!(@minisymposium)
  end
end

