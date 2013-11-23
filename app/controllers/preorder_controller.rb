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

    charge = Stripe::Charge.create(
      :amount => self.amount,
      :currency => Settings.currency,
      :customer => client.id,
      :description => Settings.payment_description
    )

    raise Exception.new("Couldn't charge Card. Please try again") unless charge.paid
    options = {
      :user_id => @user.id,
      :price => Settings.price,
      :name => Settings.product_name
    }
    @order = Order.fill!(options)
    redirect_to :action => :share, :uuid => @order.uuid
  end

  def amount
    (Settings.price * 100).to_i
  end

  def share
    @order = Order.find_by(:uuid => params[:uuid])
  end

  def ipn
  end
end
