class PaymentOptionChecker

  def initialize(payment_option_id)
    @payment_option_id = payment_option_id
  end

  def price
    if use_payment_options?
      payment_option.try(:amount)
    else
      Settings.price
    end
  end

  def payment_option
      PaymentOption.find(payment_option_id)
      raise Exception.new("No payment option was selected") if payment_option.nil?
    end
  end


private
  def use_payment_options?
    Settings.use_payment_options
  end
end
