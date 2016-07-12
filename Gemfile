source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.6'
gem 'json', '~> 1.8', '>= 1.8.3'

group :development do
  gem 'sqlite3'
  gem 'pry-rails'
  gem 'annotate', '~> 2.6.10'
end

group :production do
  gem 'thin'
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 4.0.0'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.5', '>= 3.5.1'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers', '~> 3.0'
end

# jQuery
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 5.0', '>= 5.0.5'

# Kickstarter's awesome Amazon Flexible Payments gem
gem 'amazon_flex_pay', '~> 0.11.0'

# Configuration File
gem 'config', github: 'railsconfig/config'

# For Heroku
gem 'rails_12factor'
