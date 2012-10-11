AmazonFlexPay.access_key = Settings.amazon_access_key
AmazonFlexPay.secret_key = Settings.amazon_secret_key
AmazonFlexPay.go_live! if Rails.env.production?