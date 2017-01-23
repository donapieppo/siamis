class AcceptanceMailer < ApplicationMailer
  def presentation_accepted(author)
    @user = author.user
    mail(to: @user.email, subject: 'Prentation accepted in Siam-is 18')
  end
end
