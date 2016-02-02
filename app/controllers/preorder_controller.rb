class PreorderController < ApplicationController
  require 'scalablepressclient' 
  skip_before_action :verify_authenticity_token, :only => :ipn

  require "stripe"
  Stripe.api_key = ENV['STRIPE_API_KEY']

  def index
  end
  
  def decide
    case params[:to_action]
    when "order"
      order
    when "scalablepresscall"
      scalablepress_call
    when "scalablepressorder"
      scalablepress_order
    end
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
    @user.update(stripe_charge_id: charge.id)
    session[:user_order] = { user_id: @user.id, order_uuid: @order.uuid }
    respond_to do |format|
      format.json { render json: { path: share_path(@order.uuid), shipping: params[:shipping] } }
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
  
  def scalablepress_call
    files = define_elements_scalable("product", "begin_quote", params)
    respond_to do |format|
      format.json { render json: files.as_json }
    end
  end
  
  def scalablepress_order
    token = params[:token]
    pf = ScalablepressClient.new
    response = pf.place_order(token)
    
    @user = User.find(session[:user_order][:user_id])
    @user.update(api_order_id: response[:order_id], order_data: response[:answer])
    
    respond_to do |format|
      format.json { render plain: share_path(session[:user_order][:order_uuid]) }
    end
  end
  
  def define_elements_scalable(request, type_of_request, params)
    elements = {}
    case type_of_request
    when 'begin_quote'
      case request
      when 'product'
        elements[:path] = "quote"
        elements[:gender] = params[:gender]
        elements[:size] = params[:size]
        elements[:product] = elements[:gender] == 'male' ? "gildan-ultra-cotton-t-shirt" : "gildan-ultra-ladies-t-shirt"
        elements[:address_name] = params[:address][:names]
        elements[:address_address] = params[:address][:address]
        elements[:address_city] = params[:address][:city]
        elements[:address_state] = params[:address][:state]
        elements[:address_zip] = params[:address][:zip]
        elements[:address_country] = params[:address][:country]
        test = test_shirt_availability(elements)
        session[:user_order].deep_merge!({ name: elements[:address_name]})
      end
    end
    return test if test
  end
  
  def test_shirt_availability(elements)
    files = []
    if elements[:gender] == 'male'
      colors = Settings.m_colors
      colors_hex = Settings.m_hex
    else
      colors = Settings.w_colors
      colors_hex = Settings.w_hex
    end
    colors.each_with_index do | color, i |
      pf = ScalablepressClient.new
      elements.deep_merge!({color: color})
      response = pf.start_request(elements, true)
      if response[:status] == "bad_value"
        case response[:path]
        when "products[0]"
          response.delete(:path)
          response.delete(:message)
          files[i.to_i] = response.deep_merge!({ status: 'error', type: "product", field: "availability", size: elements[:size], gender: elements[:gender] })
        when "address[state]"
          return [{ status: "error", type: "address", field: "state" }]
        when "address[zip]"
          return [{ status: "error", type: "address", field: "zip" }]
        end
      else
        response.deep_merge!({ color: color, size: elements[:size], gender: elements[:gender], color_hex: colors_hex[i.to_i] })
        files[i.to_i] = response
      end
    end
    return files
  end
  
  def ipn
  end
end
