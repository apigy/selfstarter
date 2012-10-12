AmazonFlexPay.access_key = Settings.payment_processor.amazon.access_key
AmazonFlexPay.secret_key = Settings.payment_processor.amazon.secret_key
AmazonFlexPay.go_live! if Rails.env.production?
