class PreorderController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => :ipn

  require "stripe"
  Stripe.api_key = Settings.stripe_api_key

  def index
  end

  def checkout
  end

  def order
    @user = User.find_or_create_by(:email => params[:email])
    client = Stripe::Customer.create(
      :email => params[:email]
    )
    card = client.cards.create(:card => params[:stripe_token])
    client.default_card = card.id
    order_details
    charge = Stripe::Charge.create(
      :amount => @integer_amount,
      :currency => @currency,
      :customer => client.id,
      :description => @description
    )

    raise Exception.new("Couldn't charge Card. Please try again") unless charge.paid
    options = {
      :user_id => @user.id,
      :price => @amount, #store in decimal in db, not integer
      :currency => @currency,
      :name => Settings.product_name,
      :payment_option_id => @payment_option_id
    }
    @order = Order.fill!(options)
    redirect_to :action => :share, :uuid => @order.uuid
  end

  def order_details
    if Settings.use_payment_options
      @payment_option_id = params['payment_option']
      raise Exception.new("No payment option was selected") if @payment_option_id.nil?
      payment_option = PaymentOption.find(@payment_option_id)
      @amount = payment_option.amount
      @currency = payment_option.currency
      @description = payment_option.description
    else
      @amount = Settings.price
      @currency = Settings.currency
      @description = Settings.payment_description
    end
    @integer_amount = (@amount * 100).to_i # to integer
  end

  def share
    @order = Order.find_by(:uuid => params[:uuid])
  end

  def ipn
  end
end
