class LatexController < ApplicationController
  # before_action :user_in_organizer_committee!
  skip_before_action :authenticate_user!

  def index
  end

  def plenaries
    @conference_sessions = Plenary.includes(schedules: :room, presentation: [authors: :user], organizers: :user).order('schedules.start, users.surname').all
  end

  def minitutorials
    @conference_sessions = Minitutorial.includes(schedules: :room, presentation: [authors: :user], organizers: :user).order('schedules.start, users.surname').all
    render action: :plenaries
  end

  def program
  end

  def program_glance
  end

  # abstracts
  def minisymposia
    @conference_sessions = Minisymposium.order(:number).includes(:presentations)
  end

  def contributed
    @conference_sessions = ContributedSession.order(:number).includes(:presentations)
    render action: :minisymposia
  end

  def posters
    @posters = PosterSession.order(:number).includes(:presentations)
  end

  def poster_abstracts
    @posters = PosterSession.order(:number).includes(:presentations)
  end

  def speakers_and_organizers
    # @users['d']['Donatini, Pietro'] = ['10:30 Tue (MS01)', ...] 
    @users = Hash.new {|hash, key| hash[key] = Hash.new {|hash2, key2| hash2[key2] = []}}

    Schedule.order(:start).includes(conference_session: [presentations: [roles: :user]]).each do |schedule|
      # MS60-3
      what = schedule.conference_session_abbr

      day_and_hour = I18n.l(schedule.start, format: :day_and_hour)

      # organizers
      schedule.conference_session.organizers.each do |organizer|
        add_to_users(organizer.user, what, day_and_hour)
      end

      # speakers
      schedule.presentations.each do |presentation|
        add_to_users(presentation.speaker.user, what, day_and_hour, 1)
      end
    end
    Presentation.poster.each do |presentation|
      add_to_users(presentation.speaker.user, "PP1", "Tue 18:30, Wed 11:30")
    end
  end

  def doors
  end

  private

  def add_to_users(user, what, day_and_hour, speak = false)
    initial = user.surname.gsub(/^(van|da|de|di) /, '')[0].upcase.gsub('Ö', 'O')
    @users[initial][user.cn_militar] << "\\textbf{#{what}} #{day_and_hour} #{speak ? '\\siammicrophone \\ ' : ''} (p.\\pageref{#{what}})"
  end
end
