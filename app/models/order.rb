class Order < ActiveRecord::Base
  attr_accessible :address_one, :address_two, :city, :country, :number, :state, :status, :token, :transaction_id, :zip, :shipping, :tracking_number, :name, :price, :phone, :expiration
  attr_readonly :uuid
  before_validation :generate_uuid!, :on => :create
  belongs_to :user
  self.primary_key = 'uuid'

  # This is where we create our Caller Reference for Amazon Payments, and prefill some other information.
  def self.prefill!(options = {})
    @order          = Order.new
    @order.name     = options[:name]
    @order.user_id  = options[:user_id]
    @order.price    = options[:price]
    @order.number   = Order.next_order_number
    @order.save!

    @order
  end

  # After authenticating with Amazon, we get the rest of the details
  def self.postfill!(options = {})
    @order = Order.find_by_uuid!(options[:callerReference])
    @order.token             = options[:tokenID]
    if @order.token.present?
      @order.address_one     = options[:addressLine1]
      @order.address_two     = options[:addressLine2]
      @order.city            = options[:city]
      @order.state           = options[:state]
      @order.status          = options[:status]
      @order.zip             = options[:zip]
      @order.phone           = options[:phoneNumber]
      @order.country         = options[:country]
      @order.expiration      = Date.parse(options[:expiry])
      @order.save!

      @order
    end
  end

  def self.next_order_number
    if Order.count > 0
      Order.order("number DESC").limit(1).first.number.to_i + 1
    else
      1
    end
  end

  def generate_uuid!
    begin
      self.uuid = SecureRandom.hex(16)
    end while Order.find_by_uuid(self.uuid).present?
  end

  # Implement these three methods to
  def self.goal
    Settings.project_goal
  end

  def self.percent
    (Order.current.to_f / Order.goal.to_f) * 100.to_f
  end

  # See what it looks like when you have some backers! Drop in a number instead of Order.count
  def self.current
    Order.where("token != ? OR token != ?", "", nil).count
  end

  def self.revenue
    Order.current.to_f * Settings.price
  end

  validates_presence_of :name, :price, :user_id
end
