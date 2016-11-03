class RegistrationMailer < ApplicationMailer
  def welcome (user, password, for_what)
    @user     = user
    @password = password
    @for_what = for_what
    mail(to:      @user.email,
         subject: "Welcome Siam-is18") 
  end
end
