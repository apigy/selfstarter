class PreorderController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => :ipn

  if Settings.payment_processor == "stripe"
    require "stripe"
    Stripe.api_key = ENV['STRIPE_API_KEY'] || Settings.stripe_api_key
  end

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

    @order = Order.prefill!(:name => Settings.product_name, :price => price, :user_id => @user.id, :payment_option => payment_option)

    # This is where we process the credit card
    if Settings.payment_processor == "stripe"
      # For stripe payments, we process the payment immediately (no callback needed)
      client = Stripe::Customer.create(
        :email => params[:email]
      )
      card = client.cards.create(:card => params[:stripe_token])
      client.default_card = card.id

      charge = Stripe::Charge.create(
        :amount => (price * 100).to_i,
        :currency => "usd",
        :customer => client.id,
        :description => Settings.payment_description
      )

      raise Exception.new("Couldn't charge Card. Please try again") unless charge.paid
      options = {
        :callerReference => @order.uuid,
        :tokenID => charge.id
      }
      @order = Order.postfill!(options)
      redirect_to :action => :share, :uuid => @order.uuid
    else
      # This is where all the Amazon magic happens. We create a multi-use token with Amazon, letting us charge the user's Amazon account
      # Then, if they confirm the payment, Amazon POSTs us their shipping details and phone number
      # From there, we save it, and voila, we got ourselves a preorder!
      port = Rails.env.production? ? "" : ":3000"
      callback_url = "#{request.scheme}://#{request.host}#{port}/preorder/postfill"
      redirect_to AmazonFlexPay.multi_use_pipeline(@order.uuid, callback_url,
                                                   :transaction_amount => price,
                                                   :global_amount_limit => price + Settings.charge_limit,
                                                   :collect_shipping_address => "True",
                                                   :payment_reason => Settings.payment_description)
    end
  end

  def postfill
    # Callback used by Amazon Payments, but not by Stripe
    unless params[:callerReference].blank?
      @order = Order.postfill!(params)
    end
    # "A" means the user cancelled the preorder before clicking "Confirm" on Amazon Payments.
    if params['status'] != 'A' && @order.present?
      redirect_to :action => :share, :uuid => @order.uuid
    else
      redirect_to root_url
    end
  end

  def share
    @order = Order.find_by(:uuid => params[:uuid])
  end

  def ipn
  end
end
