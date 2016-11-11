class RegistrationMailer < ApplicationMailer
  def welcome (user, password, for_what)
    @user     = user
    @password = password
    @for_what = for_what
    @relative_to = @for_what.is_a?(Author) ? @for_what.presentation : @for_what.conference_session
    mail(to:      @user.email,
         subject: "Welcome Siam-is18") 
  end
end
