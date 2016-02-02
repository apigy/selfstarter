##
#
# This is based on Printful API but tweaked to accomodate scalablepress API
#
# version 1.0
# copyright 2016 
#
##

require 'net/http'
require 'json'
require 'uri'

module ScalablepressClientModule

	API_URL = 'https://api.scalablepress.com/v2/'
	USER_AGENT = 'Scalablepress module from 2theGig'
  SCALABLE_KEY = Settings.scalable_key
  
  def start_request(elements, quote=false)
    if quote
      basic_uri = API_URL + elements[:path]
      uri = URI.parse(basic_uri)
    end
    response = start_api(basic_uri, elements)
  end

	# creates uri and calls response
  def start_api(uri, elements)
    parameters = {}
    passkey = SCALABLE_KEY
    designId = Settings.designId
  
    c = Curl::Easy.new
    c.url = uri
    c.http_auth_types = :basic
    c.username = ''
    c.password = passkey
    c.verbose = true
    c.encoding = ''
    c.http_post(Curl::PostField.content('type', 'dtg'),
                Curl::PostField.content('products[0][id]', elements[:product].to_s),
                Curl::PostField.content('products[0][color]', elements[:color].to_s),
                Curl::PostField.content('products[0][size]', elements[:size]),
                Curl::PostField.content('products[0][quantity]', '1'),
                Curl::PostField.content('address[name]', elements[:address_name].to_s),
                Curl::PostField.content('address[address1]', elements[:address_address].to_s),
                Curl::PostField.content('address[city]', elements[:address_city].to_s),
                Curl::PostField.content('address[state]', elements[:address_state].to_s),
                Curl::PostField.content('address[zip]', elements[:address_zip].to_s),
                Curl::PostField.content('address[country]', elements[:address_country].to_s),
                Curl::PostField.content('designId', designId))
    response = JSON.parse(c.body_str, symbolize_names: true)
    check_availability_status(response, elements[:color])
  end
  
  
  def check_availability_status(response, color)
    if !response[:orderToken]
      if response[:statusCode] == 400
        response[:issues].each do |issue|
          return { status: issue[:code], path: issue[:path], message: issue[:message], color: color }
        end
      else
        response[:orderIssues].each do |issue|
          return { status: issue[:code], path: issue[:path], message: issue[:message], color: color }
        end
      end
    else
      return { status: 'ok', total: response[:total], subtotal: response[:subtotal], fees: response[:fees], tax: response[:tax], shipping: response[:shipping], orderToken: response[:orderToken], mode: response[:mode] }
    end
  end
  
  def place_order(token)
    passkey = SCALABLE_KEY
    uri = API_URL + 'quote/' + token
    
    c = Curl::Easy.new
    c.url = uri
    c.http_auth_types = :basic
    c.username = ''
    c.password = passkey
    c.verbose = true
    c.encoding = ''
    c.perform
    response = c.body_str
    
    if response['total'].to_f <= 30.00
      uri = API_URL + 'order'
      c.url = uri
      c.http_post(Curl::PostField.content('orderToken', token))
      response = c.body_str
    else
      #send email
    end
    return { order_id: token, answer: response }
  end
end

class ScalablepressClient
   include ScalablepressClientModule
end

# Generic Scalablepress exception
class ScalablepressException < RuntimeError
end

# Scalablepress exception returned from the API
class ScalablepressApiException < ScalablepressException
  def initialize(code)
    @code = code
  end
  attr_accessor :code
end