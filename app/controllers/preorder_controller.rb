class PreorderController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => :ipn
  include Scalablepressclient
  require "stripe"
  Stripe.api_key = ENV['STRIPE_API_KEY']

  def index
  end
  
  #our small API
  def decide
    case params[:to_action]
    when "order"
      order
    when "scalablepresscall"
      scalablepress_call
    when "scalablepressorder"
      scalablepress_order
    end
  end
  

  def checkout
    #@stripe = Stripe.api_key
  end

  def order
    # first we take the parameters that we sent so we can use them. We could use directly params[:xxxx] when setting fields but this way it's more explicit and shorter to write further down.
    # as you can see by the structure of the ajax call, we set token and email field as independent fields, and then we set another field with the paymentinfo. Since the paymentinfo is an hash we need to fetch it
    # by statins params[:paymentinfo], followed by the "key" we want, in this case we want the amount, the description and the option ID.
    token = params[:token]
    email = params[:email]
    amount = params[:paymentinfo][:amount]
    description = params[:paymentinfo][:description]
    p_id = params[:paymentinfo][:p_id]
    # here what we do is we search our database to check if a user with this email already exists. If it does what we set it to @user, if it doesn't we create a new record on the DB and set it to @user
    @user = User.find_or_create_by(email: email)
    # here we create a customer. This Stripe::Customer.create is available because we include the stripe gem library that has these things already predefined. We create a customer with the email and the charge token we fetched from the stripe callback
    client = Stripe::Customer.create(
      email: email,
      source: token
    )
    # here we create the actual charge. Since we assigned to "client" a new stripe customer object, we are able to retrieve an ID specifically for this customer by calling the method .id on our object (because we have the stripe gem of course). The remaining options are taken from the params we used before.
    charge = Stripe::Charge.create(
      amount: amount,
      currency: 'USD',
      customer: client.id,
      description: description,
    )
    # since stripe requires an integer value to create the charge we have passed the "amount" as an integer (instead of 10$ equating 10.00 it equates to 1000)
    # and that's all nice for stripe but for our database we are using decimals, so we need to convert that in order to fill our DB. This would probably be better to be "consistent" and using the same rules for the DB as our dependencies (stripe) require. But for now it's like this. So we assing to "amount_decimal" the "amount", stripping it from the last 2 characters - [0...-2]. And then we re-assing amount_decimal to itself but we call the method .to_f , which turns an integer into a floating. So we passed for instance 1000 (which is 10$), we turned it into 10, and then with .to_f we made it 10.00. And it's this that gets recorded into the DB
    amount_decimal = amount[0...-2]
    amount_decimal = amount_decimal.to_f
    # in case there's any ERROR on the charge - which shouldn't be happening anyway, we raise an Exception - this is an "hard-brake" on the application. We check if the transaction was successfully by calling the method .paid on our charge object. If it returns true, everything is fine, if it return false we have problems.
    raise Exception.new("Couldn't charge Card. Please try again") unless charge.paid
    #if we reach this point right after the safe-guard clause, it means the charge was completed, so we can now create an hash with all the details we want saved into a new "order" record. The options are quite straightfoward. We had set an user to @user instance variable, so we can use this to return the .id of it. We already converted the amount to decimal, we know the currency is dollars, we have the product name in the settings.yml, we have the id of the payment option and we have the charge.id 
    options = {
      user_id: @user.id,
      price: amount_decimal, #store in decimal in db, not integer
      currency: 'USD',
      name: Settings.product_name,
      payment_option_id: p_id,
      transaction_id: charge.id
    }
    # so now we call a method of our Order model, which is ".fill!" with our hash passed on as argument. what does fill! do? It's not a standard object method. It's defined on the "order" model. If you open it up you can see what it does and it becomes more clear. Basically the "fill!" just creates the actual record on the DB.
    @order = Order.fill!(options)
    # after we created an Order record for this order we update the "stripe_charge_id" on our @user object. The update method saves not only the object it refers to, but also the DB record. This way we also have the corresponding stripe charge in our user record and if in the future we need to use it, like in a back-end to list the associated charges with an user we can call simply @user.stripe_charge_id
    @user.update(stripe_charge_id: charge.id)
    # here we use Rails session object to save an hash containing both the @user.id (so we can use it later, and the order_uuid. The order_uuid is so that we can render the path for sharing and the @user.id is so that in case this charge entails a t-shirt shipping, later on, since each session object is unique to each user active on the wbesite, we can return this :user_order hash from the session to fetch the corresponding user as well as the right sharing path to redirect once the t-shirt process is finished. In case this charge was not including a t-shirt, we pass the share_path() for this specific user/order so that we can redirect the. We also have to render the shipping addresses, so in case we need to ship the t-shirt, we'll have the addresses available. We don't need to check it further because stripe makes sure our addresses are real (at least, country, state, city). So we are confident we can use them with scalable_press api
    session[:user_order] = { user_id: @user.id, order_uuid: @order.uuid }
    notification_mail('payment', @order, @user)
    # this is the block that responds to the call. We can use format.json, or format.html in this case doesn't matter. The "render json:" says that instead of rendering a view, we render a JSON object, and this is what the success callback in checkout.js will grab under the name "data". So it means we'll have available an hash, named data, with two key-values. One "path" another one "shipping". So now back to the guide document to follow through
    respond_to do |format|
      format.json { render json: { path: share_path(@order.uuid), shipping: params[:shipping] } }
    end
  end


  def share
    @order = Order.find_by(:uuid => params[:uuid])
  end
  
  #we don't need this anymore
  def printfulcall
    pf = PrintfulClient.new(PRINTFUL_KEY)
    files = pf.get('files')
    pf.post('orders', {
      recipient: {
        name: "Test User",
        address1: "Test Adress Somewhere #123",
        city: "San Diego",
        state_code: 'CA',
        country_code: 'US',
        zip: '91502'
      },
      items: [
        {
          variant_id: 1138,
          quantity: 1,
          name: 'ToTheGIG Tee',
          files: [ {
            id: '1205889',
          }
        ]
        }
      ]
    })
    orders = pf.get('orders')
    respond_to do |format|
      format.json { render json: orders }
    end
  end
  
  # once the path /preorder/scalablepresscall is hit by our AJAX call we call this function
  def scalablepress_call
    #this calls the next function - we should probably even move this to the scalablepressclient module
    files = define_elements_scalable("product", "begin_quote", params)
    respond_to do |format|
      format.json { render json: files.as_json }
    end
  end
  
  #here is where we define the elements for our api call. Right now it's overkill for what it does, but you can see that we could reutilise this by creating more case/switch statements inside, that could handle
  #different calls. So maybe if you called instead of "begin_quote" you called something else it would do something else.
  def define_elements_scalable(request, type_of_request, params)
    #we initiate a variable as an hash
    elements = {}
    #we start a switch statement with the "type_of_request" argument. As of now it can only take "begin_quote".
    case type_of_request
    when 'begin_quote'
      #here we start a different switch statement for the "request" argument that was passed to this function. as before right now it can only assume one value
      case request
      when 'product'
        #here we set all key values of our hash, by fetching directly the params we have passed as an argument. params is a rails hash, and it works exactly like that.
        #path is the path we will use to build our url for querying the api. In this case since it's the first step we set it to "quote"
        elements[:path] = "quote"
        #the other values
        elements[:gender] = params[:gender]
        elements[:size] = params[:size]
        #this one is the only one that is different. This is a terniary if statement. It works as follows
        # name_of_variable_to_assing = condition ? if_true : if_false
        # So in this case it attributes either the male or female model, fetched from the settings.yml, to elements[:product], depending on the condition if "elements[:gender]" is male or not
        elements[:product] = elements[:gender] == 'male' ? Settings.m_shirt_model : Settings.w_shirt_model
        #you see here, since the address information was itself an hash, we need to use params[:address] which points to our hash and then [:the_key] we want from that hash
        elements[:address_name] = params[:address][:names]
        elements[:address_address] = params[:address][:address]
        elements[:address_city] = params[:address][:city]
        elements[:address_state] = params[:address][:state]
        elements[:address_zip] = params[:address][:zip]
        elements[:address_country] = params[:address][:country]
        #then after we have the elements hash completed, we call the test_shirt_availability function, passing the hash as it's argument
        test = test_shirt_availability(elements)
        #here what we do is - we had saved previously some information on the session object of Rails, and we saved it as a "hash". We can merge new keys into any hash by either
        #calling object_name.merge! or object_name.deep_merge! - the difference is deep_merge! can go inside keys that hold other hashes and replace values.
        #image we had this hash
        # hash_example = {
        # sample: {
        #   sample_2: two,
        #   sample_1: one
        #  }
        # }
        # if I call hash_example.merge!({ sample: { sample_3: three }}) - this results in a hash with { sample: { sample_3: three } }
        # if I call .deep_merge!({ sample: { sample_3: three }}) - this results in { sample: { sample_2: two, sample_1: one, sample_3: three }}
        # in this case it doesn't really matter but I prefer to use deep_merge always - although if it's a big app or a lot of merging and you don't need the deep_merge
        # it slows down the app and we should use merge! or deep_merge! according to our needs
        # so we merge a new key with the user name that was input in the stripe form into our session[:user_order] hash.
        session[:user_order].deep_merge!({ name: elements[:address_name]})
      end
    end
    #we return test if test exists. So this is here only in case we need to expand our options in the switch cases. It's to explicitly return the test_shirt_availability we called earlier
    return test if test
  end
  
  #so this function is called on the previous function and is what eventually sets the details to test for availability
  def test_shirt_availability(elements)
    #we initiate an empty array
    files = []
    # we fetch the user
    user = User.find(session[:user_order][:user_id])
    # we initiate a client to send the notification email
    #here we differentiate according to the gender. If it's male we load the "color" name for the male options along with the hex color we want to match to that option
    #from the settings.yml
    if elements[:gender] == 'male'
      colors = Settings.m_colors
      colors_hex = Settings.m_hex
    else
      colors = Settings.w_colors
      colors_hex = Settings.w_hex
    end
    #since in settings.yml we set the colors as an array, we can call on it the method .each_with_index, what this does it cycles through all elements of the array and passes to
    #the following code both the value of the current element in the array, as well as it's position (index) in the array. Since we know that colors and colors_hex are synchronized
    # - in the sense that we have two arrays in which each index matches the index of the other - we only need to do this with one of the arrays.
    #Since we might have availability for one color and that size but not for the other one, we use this .each function to try both. And if you add values to the arrays in "settings.yml"
    #this will run those availability tests for those colors as well which means you can include as many colors as you want
    colors.each_with_index do | color, i |
      # now we merge into the "elements" hash we had passed into this function the colors - since now we know which colors we have because we differentiated according to gender
      elements.deep_merge!({color: color})
      # here we store the first response. "pf" is the ScalablepressClient instance we initiated two lines above. So we call the method start_request, passing it the elements hash and true
      # as the second argument - we'll use the true to decide what to do - please check scalablepressclient.rb in the lib folder on the root folder of the app
      # this response assumes the value of the hash we returned at last in check_availability_status function
      response = start_request(elements)
      # since we standardized the answer we can now easily check if there's availability or not - no matter what the issue we put it as the "status" key (bad_value is what the api returns)
      if response[:status] == "bad_value" || response[:status] == "missing_field"
        #so if in the "status" key we had a bad_value then we know there's a problem and now we'll check where is the problem. The API always returns the field where there's a problem
        #and so we create a switch/case statement using the key "path" (we standardized this that's why we can use it like this - now all errors are organized the same)
        case response[:path]
          #if we have "status"=bad_value and "path"=products[0] it means the combination of the particular color we are testing right now and the size the user asked for, isn't available
        when "products[0]"
          #we don't need the path nor message anymore so we delete them from the hash
          response.delete(:path)
          response.delete(:message)
          #and here we don't abort at all, because we don't know if the other colors we defined are available or not. so we try them all. what we do is, using the index from the
          #.each_with_index function we attribute an hash to that array index with the details of the error.
          #if you have 2 colors on the array as we have now. This means this cycle will first go as i = 0, so files[0] = .... and then will be run again as i=1, so files[1]
          #if you had more colors it will go on as i=2, etc,etc. We don't return nothing here, because we don't know how many colors there are to test. If it's the last one
          #it will nonetheless end the cycle and then finish the function with a "return files" which eventually returns the full array with all the errors.
          #you can see I added to the response both the size and gender so that if we need that info to debug we have it.
          files[i.to_i] = response.deep_merge!({ status: 'error', type: "product", field: "availability", size: elements[:size], gender: elements[:gender] })
        when "address[state]"
          #when we have "status"=bad_value and "path"=address[state] - we know it's a shipping address problem. In this case, and contrary to the availability problem we are
          #sure we want to stop the function right now. It's not needed to have other colors tried because the address will always be wrong. Before I was using this to display
          #the errors on the popup, but since then we moved to stripe address form we probably don't need to worry with it as it validates it itself. In case stripe accepts an
          #address that is invalid to scalable api we have a problem... But that shouldn't happen at all - and there's no way to change it since the address comes from stripe
          error = { status: "error", type: "address", field: "state", path: share_path(session[:user_order][:order_uuid]) }
          notification_mail('error', error, user)
          return [error]
        when "address[zip]"
          #this is the same as the previous
          error = { status: "error", type: "address", field: "zip", path: share_path(session[:user_order][:order_uuid])  }
          notification_mail('error', error, user)
          return [error]
        end
      else
        #otherwise, when "status" isn't "bad_value" (we could also check if it was "ok") we know this article with this particular color is available, so we use the same technique
        #as for the unavailable product. We set files[current_index] to this response - plus - since we know this is available, we also include the "colors_hex" which we will use
        #to draw the color in the next iteraction of the popup. Since colors and colors_hex should match regarding indexes, we can fetch the corresponding hex by using "i"
        response.deep_merge!({ color: color, size: elements[:size], gender: elements[:gender], color_hex: colors_hex[i.to_i] })
        files[i.to_i] = response
      end
    end
    #here we return whatever we got from the quote test to our ajax callback - so follow it on checkout.js
    notification_mail('notification', files, user)
    return files
  end
  
  #this is the last call and it's used to place the actual order
  def scalablepress_order
    #at this point we don't need to worry with anything else because the quote is valid and we can fetch the previously placed quote with the orderToken we had saved and passed as parameter
    #through the ajax call
    token = params[:token]
    #here we use the session[:user_order] we had created before to fetch the correct user by it's id in our db.
    user = User.find(session[:user_order][:user_id])
    #we make the call to the api - switch to lib/scalablepressclient.rb - method=> place_order
    response = place_order(token, user)
    #since an order will always be made effective unless the cost is higher than 30$ and since we set "response" both for returning the quote and for placing the order we can safely assume
    #we'll have those values and it won't break ever our app
    #and here we update the user instance, to save both the order_id (the token used) and the full response given by the API. This way you can double check if any inconsistency rises. And 
    #you can see if a order was placed, left on hold or anything else. We used it as .json field inside the DB becuase PostGreSQL and rails have native support for it.
    user.update(api_order_id: response[:order_id], order_data: response[:answer])
    notification_mail('order', response[:answer], user)
    #here we kick our answer to ajax, which once again uses the session hash we created before to fetch the correct redirect path!
    respond_to do |format|
      #voilá! this hits the JS front-end and we redirect to the computed result of "share_path(for_this_order_id)"
      format.json { render plain: share_path(session[:user_order][:order_uuid]) }
      #for debugging
      #format.json { render json: response }
    end
  end
  
  

  
  def ipn
  end
end
