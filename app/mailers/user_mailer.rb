class UserMailer < ActionMailer::Base
  # change the email
  default from: "admin@selfstarter.com"
  
  def welcome_email(email)
    @email = email
    mail(to: email, subject: "Thanks for Preordering with Selfstarter")
  end
end
