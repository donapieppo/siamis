class MinisymposiaController < ConferenceSessionsController
  before_action :check_deadline!, only: [:new, :create]
  before_action :user_in_organizer_commettee!, only: [:accept]

  # wait till end of proposals to show accepted Minisymposia
  def index
    @minisymposia = Deadline.can_propose?(:minisymposium) ? [] : Minisymposium.accepted
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
    redirect_to submissions_path
  end

  def accept
    Minisymposium.find(params[:id]).accept!
    redirect_to submissions_path
  end

  private

  def conference_session_params
    params[:minisymposium].permit(:name, :description)
  end

  def check_deadline!
    Deadline.can_propose?(:minisymposium) or raise ProposalClose
  end
end

