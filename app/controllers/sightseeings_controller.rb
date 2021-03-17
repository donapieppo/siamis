class SightseeingsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :user_in_organizer_committee!, except: [:index, :show]
  before_action :set_sightseeing, only: [:edit, :update, :destroy]

  def index
    @sightseeings = Sightseeing.order(:starting).all
  end

  def new
    @sightseeing = Sightseeing.new
  end

  def create
    @sightseeing = Sightseeing.new(sightseeing_params)
    if @sightseeing.save
      redirect_to sightseeings_path, notice: 'OK'
    else
      render action: :new
    end
  end

  def update
    if @sightseeing.update(sightseeing_params)
      redirect_to sightseeings_path, notice: 'OK'
    else
      render action: :edit
    end
  end

  private 

  def sightseeing_params
    params[:sightseeing].permit(:name, :description, :seats, :webpage, :image_name, :starting, :ending) 
  end

  def set_sightseeing
    @sightseeing = Sightseeing.find(params[:id])
  end
end

