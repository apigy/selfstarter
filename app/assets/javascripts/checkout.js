// this sets the actions/functions/variables that we want executed once the page is finished loading
var ready = function() {
  //this handler var holds the StripeCheckout configuration. We can do this, because we use their JS script, which is loaded on the application.html.erb header tags.
  var handler = StripeCheckout.configure({
    //the public test key
    key: $('.stripe_pk').data('pk'),
    //the image we want to show
    image: $('.imagelink').data('link'),
    //locale settings /lang/country
    locale: 'auto',
    //additional fields we want
    shippingAddress: true,
    billingAddress: true,
    //token function which is what handles the stripe call back and allows us to call whatever we want once it's successful - token is default but we added a second field that can take the shipping&billing addresses
    //in this case we named it args
    token: function(token, args) {
      //here we set the details for the transaction we want to make
      var paymentinfo = setData();
      //actual jQuery ajax call
      $.ajax({
        //the url we're directing this ajax call
              url: '/preorder/order',
        //type of call
              type: "POST",
        //type of data
              dataType: "html",
        //extra data, this will be available on our controller as params. So we'll have, a params[:token], a params[:email], a params[:shipping] and all the contents of the hash "paymentinfo" that was set with "setData()"
              data: {
                token: token.id,
                email: token.email,
                shipping: args,
                paymentinfo
              },
              //this is the sucessful callback
              success: function(data) {
                //data is whatever our app returned to this ajax call. In this particular case we returned a JSON object that we can use so we call another function and pass on the information we just retrieved along with the founder information
                selectDetails(data, paymentinfo['founder']);
              }
      });
    }
  });
  //does the binding for "payable" and for "button"
  $.each(['payable', 'button'], function() {
    //the actual binding. First we "unbind" then we create a on click event listener
    $('.' + this).unbind().on('click', function(e) {
      //prevents any default action. So when somebody "clicks" this element "e" is passed as the object of it, if "e" has any fundamental action happening we stop it with preventDefault() - this is a standard JS
      //method;
      e.preventDefault();
      //here we fetch the values for our transaction - we've embedded them in our html
      var description = $(this).data('description');
      var amount = $(this).data('amount');
      //this checks if we are either on the "single" page two options or on the multiple options page
      if (description == "option") {
        //if we are on the multiple we check if there's any choice selected
        if ($("input:checked").length > 0) {
          //if there is we fetch the correct data for making our transaction - we assing the jQuery object corresponding to a selected "input" element to "option"
          var option = $("input:checked");
          //then we can call option.siblings to find the element that is a sibling of the option and has a class of "description", then we find the "strong" tag on it, and we return the Text inside it
          //this was a way I found of passing the values into it
          description = option.siblings('.description').find('strong').text();
          //since this action also fetches ":" we need to remove it, so we call .replace
          description = description.replace(':','');
          //here we fetch the amount
          amount = option.data('amount');
          //here we add the class "chosenoption" so that later when we call the stripe function we can setData() and pick the right info
          option.addClass('chosenoption');
          
        } /* in case there is no checked option */ else {
          // we alert the user and we return false, halting this function
          alert('You have to choose an option!');
          return false
        }
      } /* in case we are not on the multiple options page */ else {
        // we can assing directly the class of "chosenoption" to $(this), because right now we are inside the ".on" click function, so the "this" refers directly to the button that was clicked, and due to
        // our structue of the html, in the single page with 2 options, the transaction info is embedded directly on the button.
        $(this).addClass('chosenoption');
      }
      // here we open stripe popup (this is also part of their library)
      handler.open({
        name: 'ToTheGig',
        //we attribute the description of our transaction that we fetched previously
        description: description,
        //the amount we fetched previously
        amount: amount,
        //and we set that we want the addresses to be included in the form - probably this can be set only on the handler
        shippingAddress: true,
        billingAddress: true
      });
    });
    
    // Close Checkout on page navigation
    $(window).on('popstate', function() {
      handler.close();
    });
  });
};

//this functions relies on our previous assignment of "chosenoption" to figure out the correct data we need for the transaction
function setData() {
  //here we create a variable _this and we assign it the jquery object with the class "chosenoption" - remember we had two different ways depending on which kind of page we were, so we chose to standardize the first part of the interaction by making sure that "chosenoption" falls on the right element so we don't have to worry with that anymore.
  var _this = $('.chosenoption')
  //here we fetch the amount
  var amount = _this.data('amount');
  //here the description
  var description = _this.data('description');
  //here the id - mostly important for the multi options page
  var p_id = _this.data('option');
  //if the option is regarding the "founder" but can be used in any option that offers a t-shirt
  var founder = _this.data('special')
  //here we build the hash that we want to return so that we can something somewhere else in our code like var something = setData(); which creates a something variable with this hash
  var information = {
    amount: amount,
    description: description,
    p_id: p_id,
    founder: founder
  };
  // unlike Ruby and Rails, Javascript doesn't implicitly return the last assignment/function executed so we have to explicitly "return" the information hash, so that it bubbles up and ends up in our variable assignment we called somewhere else. If you take - return information; - from here, you break our system.
  return information;
};

/* this was for printful call
function printfulCall(redirectTo) {
  $.ajax({
          url: '/preorder/printfulcall',
          type: "POST",
          dataType: "html",
          data: {

          },
          success: function(data) {
            alert(JSON.stringify(data));
            window.location.href = redirectTo;
          }
  });
};
*/


//this is the function that gets called once we receive a success callback from our ajax for creating a stripe charge, as you see it takes two values - data is what was returned by our app and founder is simply a  var stating if this payment includes a t-shirt order or not.
function selectDetails(data, founder) {
  //since we returned the data as a "json" object from our back-end we need to parse it so we can access it as a regular object.
  data = JSON.parse(data);
  //here we check if the payment included a t-shirt (we pass this value previously of course)
  if (founder == "founder") {
    //if it does we use magnificPopup. Since we have it loaded through application.js, all we need to do is the following.
    $.magnificPopup.open({
      //magnific popup offers pretty much all options you need, in this case we are going to use it as a "modal" popup, this means everything is blocked outside the popup
      //this way we can make sure the user has to choose the options or cancel deliberately. That is done by setting the key "modal" to true.
      //We also set it as an inline popup - this means it will load directly from the existing DOM - we can pass other values here instead to open an AJAX popup, an image popup, or iframe.
      //since the default is image type we need to explicitly say we want an inline.
      //Then we define the items that will be in this popup. Since we chose inline, we need to set the "src" (source) key to the #ID of the element. This has to match, otherwise the popup doesn't open
      //you can check it here http://dimsemenov.com/plugins/magnific-popup/documentation.html#inline-type
      items: {
        src: "#select_details"
      },
      type: 'inline',
      modal: true
    }, 0);
    //then, since we have a modal we need to create the button binding that allow users to interact with it. In this case we create first the one for submitting the t-shirt choice
  	$(document).on('click', '.confirm_select_modal', function (e) {
      //first we fetch the chosen "size" value from our "select" element which has an ID of "size", we do that by fetching the jquery element, returning it's value with .val(), and lastly
      //we make it lowercase, just because
      var size = $('select#size').val().toLowerCase();
      //then we fetch the chosen gender - we do this by fetching the jquery element of input that has the name attribute as "gender", and is simultaneously "checked" (if we didn't put the checked
    // we would not fetch the right value, actually we would fetch both elements and this wouldn't work, since they're a radio group, both radio buttons have the same name, so what separates them
    // is being checked or not)
      var gender = $('input[name=gender]:checked').val()
      //then we check to see if the user has chosen one of the two gender options we provide
      if (gender) {
        //in case he did we also lowercase it
        gender = gender.toLowerCase();
      }
      //then we check if the user has selected both fields
      if (size && gender) {
        //if he has we then can proceed to the first call to scalable press - we pass again the data-hash that we have been jumping around, we pass the chosen size, and the gender and we call
        //our format_address function, that basically, prepares the shipping address
        scalablepressCall(data, size, gender, format_address(data));
      } else {
        //if one or both of the values weren't chosen by the user, we display a small alert error. We have already coded this section into the html and we had it hidden direclty with 
        // style="display: none;". This way we just need to call "show", making it "swing" in a bit less than half a second. Then we set the callback to a JS timer with setTimeout
        //what this means is that once the animation to show the alert is finished, it triggers the timer
        $('#alert_no_selection').show(400, 'swing', setTimeout(function() {
          //we set this timer to 3 seconds - 3000, which makes the alert stay 3 seconds
          $('#alert_no_selection').hide(400, 'swing');
          //then once the timer hits its mark, we hide once again the #alert section. This time we don't set any callback function to .hide()
        }, 3000));
      }
  	});
    //here we simply set that if the user clicks the button with the class "close_select_modal" we close the modal. Magnific Popup makes it really use to use. 
  	$(document).on('click', '.close_select_modal', function (e) {
      //this closes the currently opened magnificPopup. Since we can in this case only have one popup open we don't really need anything else - this will close the modal
      $.magnificPopup.close();
  	});
    
  } /* in case this callback wasn't from an option that offered a tee, we simply redirect the user to the "share" path we also retrieved through the api */ 
  else {
    window.location.href = data['path'];
  }
};

//this is a simple function used to format the address. Since we have the data hash we sent through our back-end, we can safely create those values and simply return them. We could even jump over
//the var declarations and put return { names: data['shipping']['shipping_name'], etc, etc } but it makes it less readable
function format_address(data) {
  shipping = data['shipping'];
  var names = shipping['shipping_name'];
  var country = shipping['shipping_address_country_code'];
  var address = shipping['shipping_address_line1'];
  var state = shipping['shipping_address_state'];
  var city = shipping['shipping_address_city'];
  var zip = shipping['shipping_address_zip'];
  return {
    names: names,
    country: country,
    address: address,
    state: state,
    city: city,
    zip: zip
  }
}

//so if the user has chosen both a gender and size, this function is called - the address argument is what format_address returns
function scalablepressCall(redirectTo, size, gender, address) {
  //we start by making a jquery ajax call
  $.ajax({
          url: '/preorder/scalablepresscall',
          type: "POST",
          dataType: "html",
    //here we pass the data we want to work with. The size, gender and the address which is actually the hash that was returned by format_address
          data: {
            size: size,
            gender: gender,
            address: address
          },
          //here we the call back for the ajax call success
          success: function(data) {
            //on success we call checkResponse and pass as an argument the data that we set our back-end to give
            //so now we need to follow this on the preorder_controller once again. Remember since the path is /preorder/scalablepresscall we will have a param[:to_action] === 'scalablepresscall' in our controller.
            checkResponse(data);
          }
  });
};

//so here is where we check what was returned by our scalablepress call to quote the items. Inside our app we already know what happened, but it's in the front-end that we need to interact
function checkResponse(data) {
  var colors = [];
  var eachToken = [];
  //again we parse the data so we can access it as a regular object
  data = JSON.parse(data);
  console.log(data);
  //we use jquery $.each with the "data" object, because we will have an array of answers as long as we have more than one colour to test. And as I wrote there, we might have a combination of color & size unavailable
  //but somehow another combination might be available. So we loop through all the answers - they end up here as [ { answer1 }, { answer2 } ], but even if only one answer it will still be [ { answer1 } ]
  $.each(data, function(i, _this) {
    console.log(i);
    console.log(_this);
    // "i" is the index and "_this" is the object itself, in this case it's the hash we passed from the response
    if (_this['status'] == 'ok') {
      // if the status is "ok" we know this color is available and we "push" it into our "colors" array, doing the same with the corresponding "orderToken"
      colors.push(_this['color_hex']);
      eachToken.push(_this['orderToken']);
    } else {
      // if the status isn't "ok" then we check which kind of error. right now the address part doesn't work as we've changed it to stripe address, but before this was how we checked if the address was valid.
      switch (_this['type']) {
      case 'address':
        alert("There is a problem with your shipping address, you'll be contacted soon to sort it out!");
        $.magnificPopup.close();
        window.location.href = _this['path'];
      case 'product':
        //in case the availability is off we show the "alert" section for it
        $('#alert_not_available').show(400, 'swing', setTimeout(function() {
          $('#alert_not_available').hide(400, 'swing');
        }, 6000));
        return false;
      }
    }
  });
  //in the end, if we have any of the colors available, we just call showColors and pass to it both our arrays, containing the colors to show, and the token to finish the order corresponding to that color
  //this way we can build the next interaction with the user
  if (colors.length > 0) {
    showColors(colors, eachToken);
  }
};

function showColors(colors, eachToken) {
  //so this is how it works with no matter how many colors you insert into settings.yml. We made it so that it could take any number of values and programatically retrieve the availability for each one
  //and we do the same now to show the colors
  $.each(colors, function(i, _this) {
    //we use jquery selector targeting the element with ID color_holder . We know that inside this element there's a "column-flex" div, because we architectured the html of course. And it's inside this div
    //that we want to insert a new div, that basically has a border, is responsive to hover and has all the information as data fields to proceed with the process once clicked
    //if instead of using $.each(colors.....) we user $.each(eachToken....) then on the next line we would swap _this for colors[i] and eachToken[i] to _this
    $('#color_holder').children('.column-flex').prepend("<div class='color-choice' style='background-color: " + _this + "' data-choice='" + eachToken[i] + "'></div>");
    //after inserting this element into the div with class column-flex that is the children of a div with id color_holder we need to bind to it the click handler.
    //this is a case that if you don't use the .off('click') or .unbind() before "binding" it with .on('click') you will have problems. For instance the first inserted element will trigger fine.
    //the second element will trigger twice, and if you add more colors each one will trigger one more time than the previous one.
    $('.color-choice').off('click').on('click', function() {
      //now we say that whenever the user "clicks", this particular element, we fetch the data-choice field from the element (which we made to hold the orderToken) and call the scalablepressPlaceOrder function
      var token = $(this).data('choice');
      scalablepressPlaceOrder(token);
    });
  });
  //we finish this part off by hiding the submit button, hiding the details_holder section and showing the section for the colors.
  $('#submit_holder').hide(200, 'swing');
  $('#details_holder').hide(200, 'swing');
  $('#color_holder').show(400, 'swing');
};


//this one is called whenever somebody clicks one of the elements we prepared in the previous function
function scalablepressPlaceOrder(token) {
  $.ajax({
    //it follows the same structure
          url: '/preorder/scalablepressorder',
          type: "POST",
          dataType: "html",
          data: {
            //we only pass the token as it's the only thing we need at this point
            token: token
          },
          success: function(data) {
            //and we just redirect the window to the path we'll get as an answer from our back-end - switch batch to preorder_controller.api to follow through
            window.location.href = data;
            //for debugging
            //console.log(data);
          }
  });
};

//This was used before when I was validating the address. So what I did before we used the stripe address was checking if the values where at least filled. If they were, I would return them, if they were not
//I would show an alert - in the meanwhile I also took the alert section from the html but left this so you could see.
function checkStateZip() {
  var country = $('#country_country').val();
  var address = $('#address').val();
  var state = $('#state').val();
  var city = $('#city').val();
  var zip = $('#zip').val();
  if (country && state && city && zip) {
    return {
      country: country, 
      address: address,
      state: state, 
      city: city, 
      zip: zip 
    }
  } else {
    $('#alert_shipping').show(400, 'swing', setTimeout(function() {
      $('#alert_shipping').hide(400, 'swing');
    }, 3000));
    return false
  }
};

//this is a jquery function I found. Together with the isMobile code below it finds if the user agent viewing the page is mobile, and if it is, adds a css class named smalldisplay which I used in CSS to format it correctly with padding for mobile viewing
jQuery(function($) {
  if (isMobile.any()) {
    $('.maincontent').addClass('smalldisplay');
    $(document).ready(ready);
  } else if (!isMobile.any()) {
    $('.maincontent').removeClass('smalldisplay');
  }
});


var isMobile = { 
Android: function() { return navigator.userAgent.match(/Android/i); }, 
BlackBerry: function() { return navigator.userAgent.match(/BlackBerry/i); }, 
iOS: function() { return navigator.userAgent.match(/iPhone|iPad|iPod/i); }, 
Opera: function() { return navigator.userAgent.match(/Opera Mini/i); }, 
Windows: function() { return navigator.userAgent.match(/IEMobile/i); }, 
any: function() { return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows()); } };

//here is simply two statements saying that whenever an ajax call starts on this "document", we create a spinner on the element with class "glass". I've put this element hidden, so we need to show it also
//this spin JS is magic in the sense that you don't need to worry with the code. You can nonetheless check it yourself as the js is on javascripts assets folder. Calling .spin() on an element 
//creates a spinner with the color: that has been defined for that element. I also created the css for glass by making it start both at top and left 5% before the screen, and then extending it 110% down
//and to the right. This way it covers completely the whole screen. I gave it a very high z-index so that it sits above everything and doesn't allow the user to interect with the page in any way.
$(document).ajaxStart(function(){
  $('.glass').show(400, 'swing', function() {
    $('.glass').spin(); 
  });
});

//here we do the inveres of the ajaxStart. We say that whenever an ajax call finishes, we hide the element with class "glass" and we stop the spinner. simply by calling .spin(false) on an element where
//we previously called .spin(). This is too many magic and vodoo happening but it's also part of how we can build things more quickly
$(document).ajaxStop(function(){ 
  $('.glass').hide(400, 'swing', function() {
      $('.glass').spin(false);  
  });
});

//here we say that when the "document" (page) is completely loaded (ready) to execute the var ready, that we had assigned on top. so if the page is loaded, the DOM is loaded, we can initiate our stripe
//and assign the on click handlers
$(document).ready(ready);

