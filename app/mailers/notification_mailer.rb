class NotificationMailer < ApplicationMailer
  def notify_user(user, password, presentations, minisymposia)
    @user          = user
    @password      = password
    @presentations = presentations
    @minisymposia  = minisymposia

    mail(to: @user.email, subject: 'Presentation accepted for Siam-is18')
  end
end
