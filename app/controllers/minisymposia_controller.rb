class MinisymposiaController < ConferenceSessionsController
  before_action :check_deadline!, only: [:new, :create]

  def new
    @conference_session = Minisymposium.new
  end

  def create 
    @conference_session = Minisymposium.new(conference_session_params)
    if @conference_session.save 
      @conference_session.organizers.create!(user: current_user)
      redirect_to @conference_session, notice: 'The minisymposium has been created. Please add presentations.'
    else
      render action: :new
    end
  end

  private

  def conference_session_params
    params[:minisymposium].permit(:name, :description)
  end

  def check_deadline!
    Deadline.can_propose?(:minisymposium) or raise ProposalClose
  end
end

