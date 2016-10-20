class AuthorsController < ApplicationController
  before_action :force_sso_user
  before_action :set_presentation, only: [:new, :create]

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
    @author = Author.find(params[:id])
    current_user.owns!(@author)
    @author.destroy
    redirect_to @author.presentation, notice: 'OK'
  end

  private

  def author_params
    params[:author].permit(:email, :name, :surname, :affiliation, :address)
  end

  def set_presentation
    @presentation  = Presentation.find(params[:presentation_id]) 
  end
end

