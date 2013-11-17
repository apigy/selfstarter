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

    @order = Order.prefill!(:name => Settings.product_name, :price => price, :user_id => @user.id, :payment_option => payment_option)

    # This is where all the magic happens. We create a multi-use token with Amazon, letting us charge the user's Amazon account
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

  def postfill
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
