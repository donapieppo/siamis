class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  skip_before_action :check_user_fields, only: [:edit, :update]

  before_action :user_in_organizer_committee!, except: [:show, :edit, :update, :index, :mailing_list, :multiple_speakers, :affiliations] # check index!
  before_action :user_in_organizer_committee_or_cochair!, only: [:index, :mailing_list, :multiple_speakers, :affiliations] 
  before_action :set_user_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @users = User.includes(:conference_registration).order(:surname, :name)
    if params[:affiliation]
      @users = @users.where(affiliation: params[:affiliation])
    end
  end

  def show
    @user = User.find(params[:id])
    @fields = User.safe_fields
    @show_email = false
    @user_conference_sessions = @user.conference_sessions.to_a
    @user_presentations       = @user.presentations.includes(:conference_session).to_a
    @conference_registration  = @user.conference_registration

    # only accepted unless for organizer
    unless user_in_organizer_committee? or user_in_scientific_committee?
      @user_conference_sessions.select!{|x| x.accepted?}
      @user_presentations.select!{|x| x.accepted?}
    end

    if user_in_organizer_committee_or_cochair? or user_in_scientific_committee? or user_in_management_commettee?
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

  def admin_notify_new
    @user = User.find(params[:id])
    @p    = params[:p]
    redirect_to users_path, notice: 'The email has been sent'
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

  def destroy
    if @user.roles.any?
      redirect_to users_path, alert: "User has roles in databse. Please delete the user from presentations, chairs, organizing etc etc"
    else
      @user.destroy
      redirect_to users_path, notice: "The user has been deleted."
    end
  end

  def mailing_list
    @minisymposia_organizers = Organizer.includes(:user).includes(:conference_session).where('conference_sessions.type = "Minisymposium"').references(:conference_sessions).map{|r| r.user.email}.join('; ')
  end

  def multiple_speakers
    # choose fiels in roles so that id is users.id
    q = "SELECT users.*, roles.type, roles.user_id, roles.speak, COUNT(user_id) AS presentation_count FROM roles LEFT JOIN users ON user_id = users.id WHERE speak = 1 AND type='Author' GROUP BY user_id ORDER BY presentation_count DESC"
    @multiple_speakers = User.find_by_sql(q)
  end

  def affiliations
    @affiliations = User.order(:affiliation).group(:affiliation).count(:affiliation)
  end

  private 

  def user_params
    permitted = [:salutation, :name, :surname, :affiliation, :address, :country, :biography, :siag, :siam, :student, :web_page, :dietary, :banquet_tickets, :visible]
    permitted += [:email] if user_in_organizer_committee?
    params[:user].permit(permitted)
  end

  def set_minisymosium_and_minitutorial
    @minisymosium = Minisymposium.find(params[:minisymposium_id]) if params[:minisymposium_id]
    @minitutorial = Minitutorial.find(params[:minitutorial_id]) if params[:minitutorial_id]
  end

  def set_user_and_check_permission
    @user = User.find(params[:id])
    @user == current_user or user_in_organizer_committee? or raise NOACCESS
  end
end

