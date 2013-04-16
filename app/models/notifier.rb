class Notifier < ActionMailer::Base
  default :from => Settings.default_from

  # send a signup email to the user, pass in the user object that contains the user's email address
  def donate_email(user, payment_option)
  	@user = user
  	@payment_option = payment_option
    mail( :to => user.email,
    :subject => Settings.default_subject + Settings.primary_stat_verb + " of " + Settings.product_name )
  end
end