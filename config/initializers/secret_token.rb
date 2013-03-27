# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Selfstarter::Application.config.secret_token = ENV['RAILS_SECRET_TOKEN'] || '686a073cf783e29dee02cb7544762d17a7c769acf7baa148a0d9726a39e45123532418f9ce7cd3def2ca0e3d5bff9d0b9ffd41f19b0c6b6dd9d0cc10b77fc5ae'
