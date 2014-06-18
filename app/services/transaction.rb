class Transaction

  attr_reader :user, :request, :payment_option_checker, :price
  def initialize(options = {})
    @payment_option_checker = PaymentOptionChecker.new(options.fetch(:payment_option))
    @price = payment_option_checker.price
    @user = options.fetch(:user)
    @request = options.fetch(:request)
  end

  def order
    Order.prefill!(:name => Settings.product_name, :price => price,
                   :user_id => user.id, :payment_option => payment_option_checker.payment_option)
  end

  def port
    Rails.env.production? ? "" : ":3000"
  end

  def callback_url
    "#{request.scheme}://#{request.host}#{port}/preorder/postfill"
  end

  def amazon_flex_play
    AmazonFlexPay.multi_use_pipeline(order.uuid, callback_url,
                                     :transaction_amount => price,
                                     :global_amount_limit => price + Settings.charge_limit,
                                     :collect_shipping_address => "True",
                                     :payment_reason => Settings.payment_description)
  end
end
