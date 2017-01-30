class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  skip_before_action :check_user_fields, only: [:edit, :update]

  before_action :user_in_organizer_commettee!, only: [:index]
  before_action :set_user_and_check_permission, only: [:edit, :update]

  def index
  end

  def show
    @user = User.find(params[:id])
    @fields = User.safe_fields
    @show_email = false

    if user_in_organizer_commettee? or user_in_scientific_commettee?
      @fields = User.all_fields
      @show_email = true
    end
  end

  def new
    if params[:user] and params[:user][:email] 
      if @user = User.where(email: params[:user][:email]).first
      else
        @user = User.new(email: params[:user][:email])
      end
    else
      redirect_to email_users_path
    end
  end

  def create
    if params[:email] and @user = User.find(email: params[:email])
      @user.errors[:email] = 'User with this email is already registered.'
    elsif @user = User.create(user_params)
      redirect_to root_path, notice: "The user #{@user.to_s} has been added."
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to root_path, notice: 'Your account has been updated.'
    else
      render action: :edit
    end
  end


  def check_email
    respond_to do |format|
      format.json { render json: User.where(email: params[:email]).any? }
    end
  end

  private 

  def user_params
    params[:user].permit(:salutation, :name, :surname, :email, :affiliation, :address, :country, :siag, :siam, :student, :web_page)
  end

  def set_minisymosium_and_minitutorial
    @minisymosium = Minisymposium.find(params[:minisymposium_id]) if params[:minisymposium_id]
    @minitutorial = Minitutorial.find(params[:minitutorial_id]) if params[:minitutorial_id]
  end

  def set_user_and_check_permission
    @user = User.find(params[:id])
    @user == current_user or user_in_organizer_commettee? or raise NOACCESS
  end
end

