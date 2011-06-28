class UserMailer < ActionMailer::Base
  default :from => EMAIL_SENDER

  def registration_email(user)
    @user = user
    @url  = user.confirmation_url
    mail(:to => user.email,
         :subject => "User Signup App confirmation email")
  end
end
