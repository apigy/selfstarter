# Load the rails application
require File.expand_path('../application', __FILE__)

#LOAD env variables for development
app_env_vars = File.join(Rails.root, 'config', 'initializers', 'app_env_vars.rb')
# Initialize the rails application
Selfstarter::Application.initialize!
