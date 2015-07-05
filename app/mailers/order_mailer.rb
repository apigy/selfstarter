class OrderMailer < ActionMailer::Base
  default from: 'denis@stoneship.org'

  def order_confirmation(order)
    @order = order
    mail(to: @order.user.email, subject: 'Milliways order confirmation')
  end
end
