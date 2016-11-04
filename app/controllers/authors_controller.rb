class AuthorsController < ApplicationController
  before_action :set_presentation, only: [:new, :create]
  before_action :set_author_and_check_permission, only: [:make_speaker, :destroy]

  def new
    @author = Author.new
  end

  def create
    @author = @presentation.authors.new(author_params)
    if @author.save
      redirect_to @presentation, notice: 'OK'
    else
      render action: :new
    end
  end

  def destroy
    @author.destroy
    redirect_to @author.presentation, notice: 'OK'
  end

  def make_speaker
    @author.is_speaker!
    redirect_to [:edit, @author.presentation]
  end

  private

  def author_params
    params[:author].permit(:email, :name, :surname, :affiliation, :address)
  end

  def set_presentation
    @presentation  = Presentation.find(params[:presentation_id]) 
  end

  def set_author_and_check_permission
    @author = Author.find(params[:id])
    current_user.owns!(@author.presentation)
  end
end

