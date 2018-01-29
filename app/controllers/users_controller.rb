class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  skip_before_action :check_user_fields, only: [:edit, :update]

  before_action :user_in_organizer_committee_or_cochair!, except: [:index, :show, :edit, :update, :schedules]
  before_action :user_in_organizer_or_scientific_committee!, only: [:schedules]

  before_action :set_user_and_check_permission, only: [:edit, :update, :destroy]

  def index
    if user_in_organizer_committee_or_cochair? or user_in_management_committee?
      @users = User.includes(:conference_registration).order(:surname, :name)
      if params[:affiliation]
        @users = @users.where(affiliation: params[:affiliation])
      end
      if params[:country]
        @users = @users.where(country: params[:country])
      end
    else
      redirect_to participants_path and return
    end

    if params[:speakers]
      @users = @users.speakers
    end

    respond_to do |format|
      format.html
      format.csv { send_data to_csv, filename: "users-#{Date.today}.csv" }
    end
  end

  def schedules
    @res = Hash.new {|hash, key| hash[key] = Hash.new {|hash2, key2| hash2[key2] = []}}
    User.includes(roles: [conference_session: :schedules, presentation: [conference_session: :schedules]]).order(:surname, :name).each do |user|
      user.roles.each do |role|
        if role.is_a?(Author) and role.speak
          presentation  = role.presentation
          cs = role.presentation.conference_session or next
          schedule = presentation.schedule or next
          start = presentation.schedule.start 
          start or next
          @res[user][start] << { what: 'S', conference_session: cs, where: schedule.room.name }
        elsif role.is_a?(Organizer)
          cs = role.conference_session
          cs.schedules.includes(:room).each do |schedule|
            start = schedule.start
            @res[user][start] << { what: 'O', conference_session: cs, where: schedule.room.name}
          end
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { 
        send_data (CSV.generate(headers: false) do |csv|
          @res.each_key do |user|
            csv << [user, 
                    @res[user][:speaker].map { |hash_presentation| "#{hash_presentation[:when]} #{hash_presentation[:presentation]}"},
                    @res[user][:organizer].map { |hash_conference_session| "#{hash_conference_session[:conference_session]}" }
                   ].flatten
          end
        end), filename: "users-#{Date.today}.csv" 
      }
    end
  end

  def show
    @user = User.find(params[:id])
    @fields = User.safe_fields
    @show_email = false

    if (user_in_organizer_committee? or user_in_scientific_committee? or user_in_management_committee?) or (current_user and current_user == @user)
      @fields = User.all_fields
      @show_email = true
    end

    # only logged users see sessions/presentations
    if current_user 
      @user_conference_sessions = @user.conference_sessions.to_a
      @user_presentations       = @user.presentations.includes(:conference_session).to_a
      @conference_registration  = @user.conference_registration

      # only accepted unless for organizer
      unless user_in_organizer_committee? or user_in_scientific_committee?
        @user_conference_sessions.select!{|x| x.accepted?}
        @user_presentations.select!{|x| x.accepted?}
      end
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
      redirect_to users_path, alert: "User has roles in databse. Please delete the user from presentations, chairs, organizing etc etc."
    else
      @user.destroy
      redirect_to users_path, notice: "The user has been deleted."
    end
  end

  def mailing_lists
  end

  def mailing_list
    if params[:active_users]
      @title = "All active users"
      @emails = User.where('sign_in_count > 0').select(:email).map(&:email)
    elsif params[:minisymposia]
      @title = "Minisymposia Organizers"
      @emails = Organizer.includes(:user).includes(:conference_session).where('conference_sessions.type = "Minisymposium"').references(:conference_sessions).map{|r| r.user.email}
    elsif params[:minisymposia_speakers]
      @title = "Minisymposia Authors"
      @emails = Presentation.at_minisymposium.includes(authors: :user).inject([]){|emails, p| emails << p.authors.select{|a| a.speak}.map(&:email); emails}
      # @email_list = User.where(id: Presentation.not_poster.left_joins(:conference_session).where('conference_session_id is null or conference_sessions.type = "Minisymposia"').includes(:roles).map(&:roles).flatten.map(&:user_id)).select(:email).map(&:email).join('; ')
    elsif params[:contributed]
      @title = "Presentations Authors"
      @emails = Presentation.at_contributed.not_poster.includes(authors: :user).inject([]){|emails, p| emails << p.authors.select{|a| a.speak}.map(&:email); emails}
      # @email_list = User.where(id: Presentation.not_poster.left_joins(:conference_session).where('conference_session_id is null or conference_sessions.type = "ContributedSession"').includes(:roles).map(&:roles).flatten.map(&:user_id)).select(:email).map(&:email).join('; ')
    elsif params[:poster]
      @title = "Authors of posters"
      @emails = Presentation.poster.includes(authors: :user).inject([]){|emails, p| emails << p.authors.select{|a| a.speak}.map(&:email); emails}
      # @email_list = User.where(id: Presentation.poster.left_joins(:conference_session).where('conference_session_id is null or conference_sessions.type = "PosterSession"').includes(:roles).map(&:roles).flatten.map(&:user_id)).select(:email).map(&:email).join('; ')
    end
      @emails = @emails.flatten.uniq
      @size = @emails.size
      @email_list = @emails.join('; ')
  end

  # FIMXE 
  def multiple_speakers
    # NOTE: choose fiels in roles so that id is users.id
    q_all = "SELECT users.name, users.surname, users.id, COUNT(user_id) AS presentation_count FROM roles LEFT JOIN users ON user_id = users.id WHERE speak = 1 AND type='Author' GROUP BY user_id HAVING COUNT(user_id) > 1 ORDER BY presentation_count DESC, surname"
    @multiple_speakers = User.find_by_sql(q_all)

    @multiple_speakers_presentations = Presentation.includes(:conference_session, :roles).where('roles.type="Author" and roles.speak = 1').references(:role).where('roles.user_id': @multiple_speakers.pluck(:id)).inject({}) do |res, p| 
      uid = p.roles.first.user_id
      res[uid] ||= []
      res[uid] << { type: p.conference_session ? p.conference_session.type : ' - ',
                    name: p.name,
                    id:   p.id }
      res
    end
  end

  def missing_affiliation
    @user = User.where('surname is not null').where(country: nil).first
  end

  def update_affiliation
  end

  private 

  def user_params
    permitted = [:salutation, :name, :surname, :affiliation, :address, :country, :biography, :siag, :siam, :student, :web_page, :dietary, :banquet_tickets, :visible]
    permitted += [:email, :student_award] if user_in_organizer_committee?
    params[:user].permit(permitted)
  end

  def set_minisymosium_and_minitutorial
    @minisymosium = Minisymposium.find(params[:minisymposium_id]) if params[:minisymposium_id]
    @minitutorial = Minitutorial.find(params[:minitutorial_id]) if params[:minitutorial_id]
  end

  def set_user_and_check_permission
    @user = User.find(params[:id])
    @user == current_user or user_in_organizer_committee_or_cochair? or raise NoAccess
  end

  def to_csv
    attributes = [:email, :name, :surname, :affiliation, :student]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      @users.pluck(*attributes).each do |user|
        csv << user
      end
    end
  end
end

