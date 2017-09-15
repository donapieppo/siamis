class TagsController < ApplicationController
  before_action :user_in_organizer_committee!
  before_action :set_tag, only: [:edit, :update, :destroy]
  # before_action :what_for_and_check_permission, only: [:new, :create]

  def index
    @tags = Tag.order(:name).all
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(name: params[:tag][:name], global: false)
    if @tag.save
      # if @what 
      #   @what.tags << @tag
      #   redirect_to [:edit, @what]
      # else
      #   redirect_to root_path
      # end
      redirect_to tags_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @tag.update_attributes(name: params[:tag][:name], global: params[:tag][:global])
    redirect_to tags_path
  end

  def destroy
    @tag.destroy
    redirect_to tags_path
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  # def what_for_and_check_permission
  #   conference_session_id = params[:conference_session_id] || params[:minisymposium_id] || params[:minitutorial_id]
  #   if conference_session_id
  #     @what = ConferenceSession.find(conference_session_id)
  #   elsif params[:presentation_id]
  #     @what = Presentation.find(params[:presentation_id])
  #   end
  #   current_user_owns!(@what) if @what
  # end
end

