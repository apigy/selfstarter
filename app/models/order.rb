class Order < ActiveRecord::Base
  before_validation :generate_uuid!, :on => :create
  belongs_to :user
  belongs_to :payment_option
  self.primary_key = 'uuid'

  # note - completed scope removed, because any entries in Order *have* to be completed ones.

  def self.fill!(options = {}) 
    @order                    = Order.new
    @order.name               = options[:name]
    @order.user_id            = options[:user_id]
    @order.price              = options[:price]
    @order.currency           = options[:currency]
    @order.payment_option_id  = options[:payment_option_id]
    @order.number             = Order.next_order_number

    @order.save!

    @order
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
    end while Order.find_by(:uuid => self.uuid).present?
  end

  # goal is a dollar amount, not a number of backers, beause you may be using the multiple payment options component
  # by setting Settings.use_payment_options == true
  def self.goal
    Settings.project_goal
  end

  def self.percent
    (Order.revenue.to_f / Order.goal.to_f) * 100.to_f
  end

  # See what it looks like when you have some backers! Drop in a number instead of Order.count
  def self.backers
    Order.count
  end

  def self.revenue
    if Settings.use_payment_options
      PaymentOption.joins(:orders).sum(:price).to_f
    else
      Order.sum(:price).to_f
    end 
  end

  validates_presence_of :name, :price, :user_id
end
