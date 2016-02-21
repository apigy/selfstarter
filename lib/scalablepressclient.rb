#we need to require 'json' because we need to do some parsing of the curb answers
require 'json'
require 'mailgun'

module Scalablepressclient

  #we set some constants, including the base url for the API and the Scalablepress API Key - we set it in settings to point to an environment variable
	API_URL = 'https://api.scalablepress.com/v2/'
  SCALABLE_KEY = Settings.scalable_key
  
  # so this is the first call
  def start_request(elements)
    # we use the constant to the base url of the api and we add the path key from the elements hash we passed into this function.
    basic_uri = API_URL + elements[:path]
    #here we call start_api - Ruby/Rails always returns either the last assignment or function return we call, so this will bubble up to the first function that called this method
    #this function is in preorder_controller
    response = start_api(basic_uri, elements)
  end

	# here we assemble together our first call - this functions takes both the url and the elements hash with the values we need to make the call
  def start_api(uri, elements)
    #we fetch the designId from the settings.yml - in case you want to use a different design you just need to change it in settings.yml
    designId = Settings.designId
    #I've used curl as it made the operation with this API easier - I was having troubles with http and in order to not loose further time I settled for using curb
    #it also follows curl (curb is a curl wrapper for ruby)
    #we initiate a new instance of a Curl request. We call Curl::Easy.new because we don't need multiple simulatenous queries.
    c = Curl::Easy.new
    #we attribute the parsed uri to the Curl instance we initiated in "c"
    c.url = uri
    #we set the type of authentication to use on this call to :basic. This allows us to use a basic http auth that is what this API requires
    c.http_auth_types = :basic
    # when you do curl -u ":scalable_api_key" it means you're setting the username as empty and the password as the scalable_api_key - like in their examples
    # the sintax is curl -u "username:password" 
    # but if you don't set the username to an empty string, it will not authenticate using curb.
    # so we set the username to ''
    c.username = ''
    # then the password - with both these settings when we call the curl connection it will be as if we did -u ":password_api_key"
    c.password = SCALABLE_KEY
    # this just creates a verbose output when the command is run. We don't really need it, but if you test the app in localhost and open the terminal window you'll see that it
    # outputs the connection information as it is made - it's quite useful for debbuging
    c.verbose = true
    # setting enconding to '' is necessary otherwise the api call will fail as curb defaults to another type of encoding
    c.encoding = ''
    # here, since we set all the defaults for the connection, we are ready to make the connection call
    # we use .http_post which takes parameters to post. If we only needed a "get" action, we could instead just do c.perform - and this would make a get request
    # Curl::PostField.content('key', 'value') is curb's way of encoding the parameters - it's like curl -d "key=value"
    # we use the hash we passed into this function to populate the fields. We only leave two fields as static fields. The type and quantity. We convert all values from the hash
    # into strings by calling .to_s (means -> to string). This is just to make sure and make it explicit.
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
    # here we actually parse the response. After calling c.http_post -> the "c" object is given .body_str which contains the response it got
    # We know it's a JSON object, but we need to parse it in order to access it as an hash, and we include "symbolize_names: true", so that we can access the keys/values of the hash
    # by writing hash_name[:key_name]. If we didn't write "symbolize_names: true" we could only access the values by writing hash_name['key_name']. The advantage is that this way 
    # it keeps the same language as when accessing the params hash (params[:key_name]) and because they're symbols, they're much faster to access than with stringed names
    response = JSON.parse(c.body_str, symbolize_names: true)
    # now our response variables holds a symbolized hash, containing the answer from scalable API and we can pass this hash into another step of our workflow. We also pass the color,
    # because the response from the API doesn't include it 
    check_availability_status(response, elements[:color])
  end
  
  # this is the function we just called at the end of the previous one and it's here that we check what happened
  def check_availability_status(response, color)
    # so after toying around with it I found that if the quote is valid - meaning it's ready to be made into an actual order - we will always receive an orderToken in the response
    # if you want to debug it you can simply write "return response" in the top of this function and that will bubble up to the ajax call - then you just need to put a console.log 
    # on the ajax success callback and you get to see the complete answer.
    # So the first step is checking if there is an orderToken. we use the bang (!) before why? Because imagine, if there's no orderToken, response[:orderToken] is false right?
    # So we want to trigger this condition, so the way we turn something into it's opposite value (in boolean terms) is by prepending ! to the condition. This way a response without
    # an order token will trigger this condition.
    if !response[:orderToken]
      # at this point we already know we don't have a ready to order quote. So now, and this is one of the inconsistencies of the API, we need to check either if we have a problem
      # because there's not a combination of that size & color available or if there's a problem with the shipping address.
      # when there isn't availability the api returns a response with a key named "statusCode" with the value of 400, whereas when there's a problem with the shipping address it doesn't
      # return a "statusCode" key, but instead includes the issues into the "orderIssues" key. They should fix this...
      if response[:statusCode] == 400
        #if we have a statusCode of 400, then the issues will be in the "issues" key and there can be more than one teoretically so we just loop through them. Since we use a return it doesn't
        #really matter, as the first issue will simply end this function
        response[:issues].each do |issue|
          # this line returns a hash, that I structured so that we could more easily analise the issue. You can see that after passing the response through this we end up with a 
          # standardized answer that then we can more easily use
          return { status: issue[:code], path: issue[:path], message: issue[:message], color: color }
        end
      else
        #if there's no orderToken (because we're still inside that conditional) and it's not a "statusCode" of 400, then it means we have orderIssues. We do the same as with the other one
        #and return a standardized version of it with only the relevant information we need. You see, when we have errors the "color" didn't appear in the returned hash, so I passed the
        #color into this function so we could always have access to the color
        response[:orderIssues].each do |issue|
          return { status: issue[:code], path: issue[:path], message: issue[:message], color: color }
        end
      end
    else
      #in case we do have an orderToken, it means that our quote is ready to be ordered. I cleaned up the answer and made my own answer with the things I really needed. It could be slimmed
      #down a bit even further.
      return { status: 'ok', total: response[:total], subtotal: response[:subtotal], fees: response[:fees], tax: response[:tax], shipping: response[:shipping], orderToken: response[:orderToken], mode: response[:mode] }
    end
    #so this function actually ends up here, whatever the case scenario it returns a hash with some information - this bubbles up to the function/method that called it
    # and from there it bubbles up to the next level from which that one was called. In the end what we have is what was returned by this function, in the response variable we set
    # in preorder_controller.
  end
  
  #this is the final call we need to make
  def place_order(token, user)
    #first we create the uri to retrieve the order
    uri = API_URL + 'quote/' + token
    #then we repeat the same steps as before
    c = Curl::Easy.new
    c.url = uri
    c.http_auth_types = :basic
    c.username = ''
    c.password = SCALABLE_KEY
    c.verbose = true
    c.encoding = ''
    #but here, since we are doing a "get" request to the api to retrieve the "quote" we already made, we just need to call .perform on our instance of curl.
    c.perform
    #as before the response is saved into .body_str of our instance.
    response = c.body_str  
    #now we just make sure the value of the order is below 30$ . In the quote hash we got returned there's a 'total' key that holds the value 
    if response['total'].to_f <= 30.00
      #we already have an instance of curl opened so we just change the url
      uri = API_URL + 'order'
      c.url = uri
      #after changing the url we can just call .http_post, simply enconding a field with orderToken and the order will be made effective
      c.http_post(Curl::PostField.content('orderToken', token))
      #we save the answer
      response = c.body_str
    else
      notification_mail('not_ordered', response, user)
      #this else is in case the order total is higher than 30$ 
      #send email or do something else
    end

    #here we return both the "order" id, as well as the "full" response we got from the API - this bubbbles to the function that called this function - so back to preorder_controller.rb
    #since at this point a quote will always be placed the only thing thatcan happen is the total value being higher than 30 and we've taken care of it as well
    return { order_id: token, answer: response }
  end
  
  def notification_mail(mail_type, response, user)
    mg_client = Mailgun::Client.new Settings.mailgun_key
    message_params = {:from    => Settings.mailgun_from,
                      :to      => Settings.mailgun_to }
    case mail_type
    when 'not_ordered'
      response = JSON.parse(response)
      response.merge!(user.as_json)
      message_params.merge!( { :subject => 'T-shirt order not completed',
      :text    => JSON.pretty_generate(response) } )
    when 'error'
      response.merge!(user.as_json)
      message_params.merge!( { :subject => 'T-shirt order not completed - address problem',
      :text    => JSON.pretty_generate(response) } )
    when 'notification'
      if decide_notification(response)
        response = { response: response }
        response.merge!(user.as_json)
        message_params.merge!( { :subject => 'Somebody tried an unavailable combination',
        :text    => JSON.pretty_generate(response) } )
      else
        response = { response: response }
        response.merge!(user.as_json)
        message_params.merge!( { :subject => 'Somebody is doing an order',
        :text    => JSON.pretty_generate(response) } )
      end
    when 'payment'
      response = response.as_json
      response.merge!(user.as_json)
      message_params.merge!( { :subject => 'Payment made',
      :text    => JSON.pretty_generate(response) } )
    when 'order'
      response = { response: response }
      response.merge!(user.as_json)
      message_params.merge!( { :subject => 'Order for t-shirt placed',
      :text    => JSON.pretty_generate(response) } )
    end 
    mg_client.send_message Settings.mailgun_domain, message_params
  end
  
  def decide_notification(response)
    total = failed = 0
    response.each do |r|
      total += 1
      if r[:status] == 'error'
        failed += 1
      end
    end
    total == failed ? (return true) : (return false)
  end
end
