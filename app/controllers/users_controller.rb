class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  skip_before_action :check_user_fields, only: [:edit, :update]

  before_action :user_in_organizer_committee_or_cochair!, except: [:index, :show, :edit, :update, :schedules, :dietaries]
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
      if params[:speakers]
        @users = @users.speakers
      end
      respond_to do |format|
        format.html
        format.csv { send_data to_csv, filename: "users-#{Date.today}.csv" }
      end
    else
      redirect_to participants_path and return
    end
  end

  # user_in_organizer_or_scientific_committee!
  def schedules
    @res = Hash.new {|hash, key| hash[key] = Hash.new {|hash2, key2| hash2[key2] = []}}
    User.includes(roles: [conference_session: :schedules, presentation: [conference_session: :schedules]]).order(:surname, :name).each do |user|
      user.roles.each do |role|
        if role.is_a?(Author) and role.speak
          presentation  = role.presentation
          cs = role.presentation.conference_session or next
          cs.is_a?(PosterSession) and next
          schedule = presentation.schedule or next
          start = schedule.start 
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

  # OPEN FOR ALL
  def show
    @user = User.find(params[:id])

    if (user_in_organizer_committee? or user_in_scientific_committee? or user_in_management_committee?) or (current_user and current_user == @user)
      @fields = User.all_fields
      @show_email = true
    else
      @fields = User.safe_fields
      @show_email = false
    end

    # only logged users see sessions/presentations
    if true 
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

  # user_in_organizer_committee_or_cochair!
  def new
    @user = User.new
  end

  # user_in_organizer_committee_or_cochair!
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
    if @user.update(user_params)
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
      @emails = Presentation.at_minisymposium.includes(authors: :user).inject([]){|emails, p| emails << p.authors.select{|a| a.speak}.map{|a| a.user.email}; emails}
      # @email_list = User.where(id: Presentation.not_poster.left_joins(:conference_session).where('conference_session_id is null or conference_sessions.type = "Minisymposia"').includes(:roles).map(&:roles).flatten.map(&:user_id)).select(:email).map(&:email).join('; ')
    elsif params[:contributed]
      @title = "Presentations Authors"
      @emails = Presentation.at_contributed.not_poster.includes(authors: :user).inject([]){|emails, p| emails << p.authors.select{|a| a.speak}.map{|a| a.user.email}; emails}
      # @email_list = User.where(id: Presentation.not_poster.left_joins(:conference_session).where('conference_session_id is null or conference_sessions.type = "ContributedSession"').includes(:roles).map(&:roles).flatten.map(&:user_id)).select(:email).map(&:email).join('; ')
    elsif params[:poster]
      @title = "Authors of posters"
      @emails = Presentation.poster.includes(authors: :user).inject([]){|emails, p| emails << p.authors.select{|a| a.speak}.map{|a| a.user.email}; emails}
      # @email_list = User.where(id: Presentation.poster.left_joins(:conference_session).where('conference_session_id is null or conference_sessions.type = "PosterSession"').includes(:roles).map(&:roles).flatten.map(&:user_id)).select(:email).map(&:email).join('; ')
    elsif params[:unregistered]
      @title = "Unregistered active users"
      registered_ids = ConferenceRegistration.pluck(:user_id)
      @emails = User.where('sign_in_count > 0').where("id NOT IN (?)", registered_ids).select(:email).map(&:email)
    elsif params[:unregistered_speakers_organizers_not_students]
      @title = "Unregistered Speakers/Organizers not students"
      registered_ids = ConferenceRegistration.pluck(:user_id)
      @emails = User.not_student.speakers_and_organizers.where("id NOT IN (?)", registered_ids).select(:email).map(&:email)
    elsif params[:students]
      @title = "Students."
      @emails = User.student.select(:email).map(&:email)
    elsif params[:registered_students]
      @title = "Registered students."
      registered_ids = ConferenceRegistration.pluck(:user_id)
      @emails = User.student.where('student_confirmed IS NULL OR student_confirmed <> 1').where(id: registered_ids).select(:email).map(&:email)
    elsif params[:no_privacy_consent]
      @title = "Speakers / Organizers without privacy consent"
      @emails = Role.speakers_and_organizers.includes(:user).where('users.visible != 1').references(:user).map{|r| r.user.email}
    elsif params[:staff]
      @title = "Staff"
      @emails = User.where(staff: true).select(:email).map(&:email)
    elsif params[:registered_not_speakers_organizers]
      @title = 'Registered not speakers/organizers'
      registered_ids = ConferenceRegistration.pluck(:user_id)
      speakers_and_organizers_ids = User.speakers_and_organizers.ids
      @emails = User.where(id: (registered_ids - speakers_and_organizers_ids)).pluck(:email)
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

  def stats
  end

  def dietaries
    (user_in_organizer_committee_or_cochair? or user_in_management_committee?) or RAISE 
  end

  def expected
    @users = User.participants
    respond_to do |format|
      format.html
      format.csv { send_data to_csv2([:cn, :affiliation_with_country]), filename: "expected_users-#{Date.today}.csv" }
    end
  end

  # FIXME temporary - to delete
  def expected2
    @users = User.participants.order(:surname, :name)
    _registered_users_ids = ConferenceRegistration.select(:user_id).map(&:user_id)
    respond_to do |format|
      format.html
      format.csv do
        send_data(
          CSV.generate(headers: false, col_sep: ";") do |csv|
            @users.each do |user|
              csv << [user.cn_militar, user.affiliation_with_country, _registered_users_ids.include?(user.id) ? 'Y' : 'N' ]
            end
          end, filename: "expected_users-#{Date.today}.csv"
        )
      end
    end
  end

  #COGNOME NOME, AFFILIAZIONE, COUNTRY, SITO per chi lo ha inserito, E-MAIL, TIPO DI REGISTRAZIONE (SIAG member / SIAM member / Non member minisymposia organizer or speaker / Non member / One day / Student  e anche Early registration/ On site registration)
  def final_sum
    @users = User.participants.includes(conference_registration: :payment)
    _speakers_and_organizers_ids = Role.speakers_and_organizers.select(:user_id).map(&:user_id)
    respond_to do |format|
      format.html
      format.csv do
        send_data(CSV.generate(headers: true, col_sep: ";") do |csv|
          csv << [ 'surname', 'name', 'affiliation', 'country', 'siam', 'siag', 'student', 'staff', 'speaker_organizer', 'payment', 'singleday', 'web page', 'email']
          @users.each do |user|
            registration = user.conference_registration or next
            payment = registration ? registration.payment : nil 
            speaker_or_organizer = _speakers_and_organizers_ids.include?(user.id)
            csv << [user.surname, user.name, user.affiliation, user.country, show_bool(user.siam), show_bool(user.siag), show_bool(user.student), show_bool(user.staff), show_bool(speaker_or_organizer), payment ? payment.amount : '0', payment ? payment.single_day : '', user.web_page, user.email]
          end
        end)
      end
    end
  end

  # FIXME temporary - to delete
  def wifi_accounts
    @users = User.participants.order(:surname, :name)
    _registered_users_ids = ConferenceRegistration.pluck(:user_id)
    respond_to do |format|
      format.html
      format.csv do
        send_data(
          CSV.generate(headers: false, col_sep: "\t") do |csv|
            @users.each do |user|
              unless user.email =~ /@[a-z]*\.?unibo.it/
                csv << [user.cn_militar + " (#{user.affiliation})", user.email]
              end
            end
          end, filename: "wifi_accounts-#{Date.today}.csv"
        )
      end
    end
  end

  private 

  def user_params
    permitted = [:salutation, :name, :surname, :affiliation, :address, :country, :biography, :siag, :siam, :student, :web_page, :dietary, :banquet_tickets, :visible]
    permitted += [:email, :staff, :student_confirmed, :exhibitor, :student_award] if user_in_organizer_committee?
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

  def to_csv(attributes = nil)
    attributes ||= [:email, :name, :surname, :affiliation, :student]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      @users.pluck(*attributes).each do |user|
        csv << user
      end
    end
  end

  # FIXME (in a hurry)
  def to_csv2(attributes)
    CSV.generate(headers: false, col_sep: ";") do |csv|
      @users.each do |user|
        csv << [user.cn, user.affiliation_with_country]
      end
    end
  end

  def show_bool(v)
    v.blank? ? '' : '*'
  end
end

