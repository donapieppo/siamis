class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  skip_before_action :check_user_fields, only: [:edit, :update]

  before_action :user_in_organizer_commettee!, only: [:index, :new, :create, :after_admin_create]
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
    @user = User.new
  end

  def admin_create
    @p = user_params
    @p[:password] = Devise.friendly_token.first(Rails.configuration.new_password_lenght)
    @user = User.new(@p)
    @user.skip_confirmation!
    if @user.save
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

  # def check_email
  #   respond_to do |format|
  #     format.json { render json: User.where(email: params[:email]).any? }
  #   end
  # end

  private 

  def user_params
    permitted = [:salutation, :name, :surname, :affiliation, :address, :country, :biography, :siag, :siam, :student, :web_page]
    permitted += [:email] if user_in_organizer_commettee?
    params[:user].permit(permitted)
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

