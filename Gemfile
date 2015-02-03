source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '4.0.0'
gem 'json', '~> 1.8.2'

group :development do
  gem 'sqlite3', '~> 1.3.10'
  gem 'pry-rails'
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
  gem 'rspec-rails', '~> 2.0'
  gem 'shoulda'
end

# jQuery
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 5.0'

# Kickstarter's awesome Amazon Flexible Payments gem
gem 'amazon_flex_pay'

# Configuration File
gem 'rails_config'

# Active Admin
gem 'activeadmin', github: 'activeadmin'

# For Heroku
gem 'rails_12factor'
