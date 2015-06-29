class PreorderController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => :ipn

  def index
  end

  def checkout
  end

  def prefill
    @user = User.find_or_create_by(:email => params[:email])

    if Settings.use_payment_options
      payment_option_id = params['payment_option']
      raise Exception.new("No payment option was selected") if payment_option_id.nil?
      payment_option = PaymentOption.find(payment_option_id)
      price = payment_option.amount
    else
      price = Settings.price
    end

    @order = Order.prefill!(
      :name => Settings.product_name,
      :price => price,
      :user_id => @user.id,
      :payment_option => payment_option,
      :email => params[:email])

    redirect_to action: :postfill
  end

  def postfill
  end

  def share
    @order = Order.find_by(:uuid => params[:uuid])
  end

  def ipn
  end
end
