class EmailReminder 

	def initialize(user)
		@user = user
	end

	def perform
		UserMailer.reminder_email(@user).deliver
	end
end