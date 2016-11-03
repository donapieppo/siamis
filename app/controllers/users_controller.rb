class UsersController < ApplicationController
  before_action :set_user_and_check_permission, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
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
      @user.errors[:email] = 'already used.'
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
      redirect_to new_registration_path
    else
      redirect_to root_path
    end
  end


  def check_email
    respond_to do |format|
      format.json { render json: User.where(email: params[:email]).any? }
    end
  end

  private 

  def user_params
    params[:user].permit(:salutation, :name, :surname, :email, :affiliation, :address, :country, :siag, :siam, :student)
  end

  def set_minisymosium_and_minitutorial
    @minisymosium = Minisymposium.find(params[:minisymposium_id]) if params[:minisymposium_id]
    @minitutorial = Minitutorial.find(params[:minitutorial_id]) if params[:minitutorial_id]
  end

  def set_user_and_check_permission
    @user = User.find(params[:id])
    @user == current_user or current_user.master_of_universe? or raise NOACCESS
  end

end

