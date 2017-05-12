class BuildingsController < ApplicationController
  before_action :user_in_organizer_committee!
  before_action :set_building, only: [:edit, :update, :destroy]

  def new
    @building = Building.new
  end

  def create
    @building = Building.new(building_params)
    if @building.save
      redirect_to buildings_path, notice: 'The building has been created.'
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @building.update_attributes(building_params)
      redirect_to buildings_path, notice: 'The building has been updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @building.delete
    redirect_to buildings_path
  end

  private

  def building_params
    params[:building].permit(:name, :lat, :lng)
  end

  def set_building
    @building = Building.find(params[:id])
  end
end

