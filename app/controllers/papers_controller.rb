class PapersController < ApplicationController
  before_action :get_presentation_and_check_permission, only: [:new, :create]

  def new
    @paper = @presentation.papers.new
  end

  def create
    @paper = @presentation.papers.build(paper_params)
    if @paper.save 
      redirect_to @presentation, notice: 'OK'
    else
      render :new
    end
  end

  def destroy
    @paper = Paper.find(params[:id])
    current_user_owns!(@paper.presentation)
    @paper.destroy
    redirect_to presentation_path(@paper.presentation_id)
  end

  private 

  def paper_params
    params[:paper].permit!
  end

  def get_presentation_and_check_permission
    @presentation = Presentation.find(params[:presentation_id])
    current_user_owns!(@presentation)
  end
end


