class LatexController < ApplicationController
  # before_action :user_in_organizer_committee!
  skip_before_action :authenticate_user!

  def index
  end

  def plenaries
    @plenaries = Plenary.includes(schedules: :room, presentation: [authors: :user], organizers: :user).order('schedules.start, users.surname').all
  end

  def minitutorials
    @minitutorials = Minitutorial.includes(schedules: :room, presentation: [authors: :user], organizers: :user).order('schedules.start, users.surname').all
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

  def speakers_and_organizers
    # @users['d']['Donatini, Pietro'] = ['10:30 Tue (MS01)', ...] 
    @users = Hash.new {|hash, key| hash[key] = Hash.new {|hash2, key2| hash2[key2] = []}}

    Schedule.order(:start).includes(conference_session: [presentations: [roles: :user]]).each do |schedule|
      # MS60-3
      what = schedule.conference_session_abbr

      day_and_hour = I18n.l(schedule.start, format: :day_and_hour)

      # organizers
      schedule.conference_session.organizers.each do |organizer|
        user_name = organizer.user.cn_militar
        initial   = user_name.gsub(/^(van|da|de|di) /, '')[0].upcase
        @users[initial][user_name] << "\\textbf{#{what}} #{day_and_hour} (p.\\pageref{#{what}})"
      end

      # speakers
      schedule.presentations.each do |presentation|
        user_name = presentation.speaker.user.cn_militar
        initial   = user_name.gsub(/^(van|da|de|di) /, '')[0].upcase
        @users[initial][user_name] << "* \\textbf{#{what}} #{day_and_hour} (p.\\pageref{#{what}})"
      end
    end
  end

  def doors
  end
end
