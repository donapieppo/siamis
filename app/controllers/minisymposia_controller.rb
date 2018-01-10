class MinisymposiaController < ConferenceSessionsController
  before_action :check_deadline!, only: [:new, :create]
  before_action :user_in_organizer_committee!, only: [:refuse, :accept]
  after_action :manual_tags, only: [:create, :update]

  # wait till end of proposals to show accepted Minisymposia
  def index
    @conference_sessions = if Date.today > Deadline.minisymposium_acceptance_end
                      # Minisymposium.includes(:schedules, [organizers: :user]).accepted.order(:name)
                      Minisymposium.accepted.order(:number, :name)
                    else
                      []
                    end
  end

  def new
    @conference_session = Minisymposium.new
  end

  def create 
    @conference_session = Minisymposium.new(conference_session_params)
    if @conference_session.save 
      @conference_session.organizers.create!(user: current_user)
      redirect_to @conference_session, notice: I18n.t(:minisymposium_created)
    else
      render action: :new
    end
  end

  def refuse
    Minisymposium.find(params[:id]).refuse!
    redirect_to admin_submissions_path(minisymposium: 1), notice: 'The minisymposium has been refused.'
  end

  def accept
    Minisymposium.find(params[:id]).accept!
    redirect_to admin_submissions_path(minisymposium: 1), notice: 'The minisymposium has been accepted.'
  end

  def print
    @minisymposia = Minisymposium.includes(organizers: :user).accepted.order(:name)
    pdf = PrintableMinisymposia.new(@minisymposia)
    send_data pdf.render, filename: "minisymposia.pdf", type: "application/pdf"
  end

  private

  def conference_session_params
    @manual_tags = params[:minisymposium].delete(:manual_tags)
    params[:minisymposium].permit(:name, :description, :parts, tag_ids: [])
  end

  def manual_tags  
    @conference_session.manual_tags = @manual_tags
  end

  def check_deadline!
    Deadline.can_propose?(:minisymposium) or raise ProposalClose
  end
end

