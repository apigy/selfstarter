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
      @payment_option = PaymentOption.find(payment_option_id)
      @price = payment_option.amount
    else
      @price = Settings.price
    end

    @payment_service = PaymentService.find_by_name(Settings.payment_service)

    @order = Order.prefill!(:name => Settings.product_name, :price => @price, :user_id => @user.id, :payment_option => @payment_option, :payment_service => @payment_service)

    port = Rails.env.production? ? "" : ":3000"
    @callback_url = "#{request.scheme}://#{request.host}#{port}/preorder/#{Settings.payment_service}_postfill"

    # Check payment service and decide what flow to follow do
    if Settings.payment_service == 'wepay'
      wepay_flow
    else 
      amazon_flow
    end

  end

  def wepay_flow
    # create Wepay object
    wepay = WePay.new(Settings.wepay_client_id, Settings.wepay_secret_key, _use_stage = (!Rails.env.production?))
    
    # create the checkout
    # https://www.wepay.com/developer/reference/preapproval#create
    response = wepay.call('/preapproval/create', Settings.wepay_access_token, {
      :require_shipping   => true,
      :period             => 'once',
      :amount             => @price,
      :mode               => 'regular',
      :fee_payer          => 'payee',
      :prefill_info       => {email: @user.email},
      :short_description        => @payment_option.nil? ? Settings.payment_description : @payment_option.description , 
      :redirect_uri       => @callback_url 
    })

    # store wepay response into order
    @order.token = response['preapproval_id']
    @order.save!

    redirect_to response['preapproval_uri']
  end

  def amazon_flow
    # This is where all the magic happens. We create a multi-use token with Amazon, letting us charge the user's Amazon account
    # Then, if they confirm the payment, Amazon POSTs us their shipping details and phone number
    # From there, we save it, and voila, we got ourselves a preorder!
    redirect_to AmazonFlexPay.multi_use_pipeline(@order.uuid, @callback_url,
                                                 :transaction_amount => @price,
                                                 :global_amount_limit => @price + Settings.charge_limit,
                                                 :collect_shipping_address => "True",
                                                 :payment_reason => Settings.payment_description)
  end

  # If callback comes from Wepay
  def wepay_postfill
    # If the user approved the 'preapproval' and 
    if params.has_key?('preapproval_id')
      @order = Order.find_by_token(params[:preapproval_id])
      unless @order.nil?
        wepay = WePay.new(Settings.wepay_client_id, Settings.wepay_access_token, _use_stage = (!Rails.env.production?))
        # Let's find the user information on Wepay end..
        response = wepay.call('/preapproval', Settings.wepay_access_token, {
          :preapproval_id       => params[:preapproval_id]
        })
        
        @order.wepay_postfill(response)
        if params['status'] != 'approved' 
          redirect_to :action => :share, :uuid => @order.uuid
        else
          redirect_to root_url
        end
      else
        redirect_to root_url
      end
    else
      redirect_to root_url
    end
  end

  # If callback comes from Amazon
  def amazon_postfill
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
