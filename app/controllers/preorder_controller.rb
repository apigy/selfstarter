class PreorderController < ApplicationController
  require 'printfulclient'
  require  'pp'
  PRINTFUL_KEY = Settings.printful_key
  
  skip_before_action :verify_authenticity_token, :only => :ipn

  require "stripe"
  Stripe.api_key = ENV['STRIPE_API_KEY']

  def index
  end

  def checkout
    #@stripe = Stripe.api_key
  end

  def order
    token = params[:token]
    email = params[:email]
    amount = params[:paymentinfo][:amount]
    description = params[:paymentinfo][:description]
    p_id = params[:paymentinfo][:p_id]
    @user = User.find_or_create_by(email: email)
    client = Stripe::Customer.create(
      email: email,
      source: token
    )
    #this is irrelevant for the new way stripe handles payments it seems
    #card = client.cards.create(:card => params[:stripe_token])
    #client.default_card = card.id 
    
    #changed this because it created instance variables but there's no need to, we create an hash in order_details that gets saved to "details" and then we can call details[:field_we_want] - it's more explicit
    #details = order_details
    charge = Stripe::Charge.create(
      amount: amount,
      currency: 'USD',
      customer: client.id,
      description: description,
    )
    amount_decimal = amount[0...-2]
    amount_decimal = amount_decimal.to_f
    raise Exception.new("Couldn't charge Card. Please try again") unless charge.paid
    options = {
      user_id: @user.id,
      price: amount_decimal, #store in decimal in db, not integer
      currency: 'USD',
      name: Settings.product_name,
      payment_option_id: p_id,
      transaction_id: charge.id
    }
    @order = Order.fill!(options)
    respond_to do |format|
      format.json { render plain: share_path(@order.uuid) }
    end
  end

  def order_details
    if Settings.use_payment_options
      payment_option_id = params['payment_option']
      raise Exception.new("No payment option was selected") if payment_option_id.nil?
      payment_option = PaymentOption.find(payment_option_id)
      amount = payment_option.amount
      #in case the seed file doesn't contain currency it assigns 'usd'
      if payment_option.currency
        currency = payment_option.currency
      else
        currency = "USD"
      end
      description = payment_option.description
    else
      amount = Settings.price
      currency = Settings.currency
      description = Settings.payment_description
    end
    integer_amount = (amount * 100).to_i # to integer
    details = {
      payment_option_id: payment_option_id,
      integer_amount: integer_amount,
      decimal_amount: amount,
      currency: currency,
      description: description
    }
  end

  def share
    @order = Order.find_by(:uuid => params[:uuid])
  end
  
  def printfulcall
    pf = PrintfulClient.new(PRINTFUL_KEY)
    files = pf.get('files')
    pf.post('orders', {
      recipient: {
        name: "Test User",
        address1: "Test Adress Somewhere #123",
        city: "San Diego",
        state_code: 'CA',
        country_code: 'US',
        zip: '91502'
      },
      items: [
        {
          variant_id: 1138,
          quantity: 1,
          name: 'ToTheGIG Tee',
          files: [ {
            id: '1205889',
          }
        ]
        }
      ]
    })
    orders = pf.get('orders')
    respond_to do |format|
      format.json { render json: orders }
    end
  end

  def ipn
  end
end
