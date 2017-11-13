class NotificationMailer < ApplicationMailer
  def notify_user(user, password, presentations, minisymposia)
    @user          = user
    @password      = password
    @presentations = presentations
    @minisymposia  = minisymposia

    mail(to: @user.email, subject: 'Presentation accepted for SIAM Conference on imaging science in Bologna, Italy')
  end

  def remind_abstract(user, presentation, conference_session)
    @user               = user
    @presentation       = presentation
    @conference_session = conference_session

    mail(to: @user.email, subject: 'Please add abstract to your presentation (SIAM Conference on imaging science in Bologna, Italy)')
  end
end
