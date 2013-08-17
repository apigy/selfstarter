class ApplicationController < ActionController::Base
  protect_from_forgery

  def email
  	UserMailer.reminder_email(@user.email).deliver
  end
end
