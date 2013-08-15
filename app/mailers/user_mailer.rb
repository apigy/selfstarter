class UserMailer < ActionMailer::Base
  default from: "someone@lockitron.com"

  def reminder_email(user)
  	@user = user
  	mail(to: @user.to_s, subject: 'Reminder! You have 48 hours to back this project!')
  end

end
