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
      cs   = schedule.conference_session
      what = I18n.l(schedule.start, format: :hour_and_day)
      cs.organizers.each do |organizer|
        user_name = organizer.user.cn_militar
        initial   = user_name.gsub(/^(van|da|de|di) /, '')[0]
        @users[initial][organizer.user.cn_militar] << "#{what} (#{cs.code_with_part(schedule.part)})"
      end
      cs.presentations.each do |presentation|
        user_name = presentation.speaker.user.cn_militar
        initial   = user_name.gsub(/^(van|da|de) /, '')[0]
        @users[initial][presentation.speaker.user.cn_militar] << "#{what} (* #{cs.code_with_part(schedule.part)})"
      end
    end
  end

  def program
  end
end
