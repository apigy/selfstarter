source 'https://rubygems.org'

raise 'Ruby should be >2.1' unless RUBY_VERSION.to_f > 2.1

gem 'rails', '4.2.1'
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
#mail-gun
gem 'mailgun-ruby', '~>1.0.3', require: 'mailgun'

#needed for rails 4.2
gem "config"

#magnific-popup
gem 'magnific-popup-rails'

group :development do
  gem 'sqlite3'
  gem 'pry-rails'
end

group :production do
  gem 'thin'
  gem 'pg'
end


gem 'sass-rails', '~> 5.0'

gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.1.0'

#added for the selection of the address to ship https://github.com/stefanpenner/country_select#usage
gem 'country_select'

#spinner for "loading" on ajax calls
gem 'spinjs-rails'

#curb - to make usage like curl
gem 'curb'

group :development, :test do
  gem 'rspec-rails'
  gem 'shoulda'
end

#turbolinks - took it off as it makes straightforward integration with externally written JS more complex than what it should
#gem 'turbolinks'

#gem 'jbuilder', '~> 2.0'

#auto-prefixer -> helps with putting the right prefixes for CSS styles that are not universally accepted
gem 'autoprefixer-rails'

# jQuery
gem 'jquery-rails'
gem 'jquery-ui-rails'


# Configuration File
gem 'rails_config'

# For Heroku
gem 'rails_12factor'
