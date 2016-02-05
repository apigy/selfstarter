class Order < ActiveRecord::Base
  before_validation :generate_uuid!, :on => :create
  belongs_to :user
  belongs_to :payment_option
  self.primary_key = 'uuid'

  # note - completed scope removed, because any entries in Order *have* to be completed ones.
  
  #micael - here is the fill! method. As you can see it's not a default method, it's just something that they coded into it. The hash is passed and then it's used to populate the fields. In the end it calls .save! which is the default method for saving object assignments into the DB, in this case since it has the ! ("bang") it executes it at the DB level creating the record. The method ends with @order, which means it returns the saved @order object. 
  def self.fill!(options = {}) 
    @order                    = Order.new
    @order.name               = options[:name]
    @order.user_id            = options[:user_id]
    @order.price              = options[:price]
    @order.currency           = options[:currency]
    @order.payment_option_id  = options[:payment_option_id]
    @order.number             = Order.next_order_number
    @order.transaction_id     = options[:transaction_id]

    @order.save!

    @order
  end

  #micael - this method here just checks if there are any orders in the DB already, in case there are (Order.count > 0) it returns 1 single value, by descending order (starting at the last) and converts it into integer adding 1 to it. Which makes sense. If the last order we have is 5, this returns 5 and adds 1, which gives us the number for the "next" order. If Order.count == 0 ( or negative), it doesn't trigger the first condition so the "else" block is executed and returns 1, meaning it's the first order.
  def self.next_order_number
    if Order.count > 0
      Order.order("number DESC").limit(1).first.number.to_i + 1
    else
      1
    end
  end

  #micael - this methods generates a random number that we use to populate the "uuid" (unique universal identifier), it's part of the SecureRandom module.
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
