
var ready = function() {
  var handler = StripeCheckout.configure({
    key: 'pk_test_dFxDEPCmXwyF4ZhFNajbinzq',
    image: $('.imagelink').data('link'),
    locale: 'auto',
    shippingAddress: true,
    billingAddress: true,
    token: function(token, args) {
      var paymentinfo = setData();
      $.ajax({
              url: '/preorder/order',
              type: "POST",
              dataType: "html",
              data: {
                token: token.id,
                email: token.email,
                shipping: args,
                paymentinfo
              },
              success: function(data) {
                selectDetails(data, paymentinfo['founder']);
              }
      });
    }
  });
  
  $.each(['payable', 'button'], function() {
    $('.' + this).unbind().on('click', function(e) {
      e.preventDefault();
      //selectDetails("data", paymentinfo.founder);
      // Open Checkout with further options
      var description = $(this).data('description');
      var amount = $(this).data('amount');
      if (description == "option") {
        if ($("input:checked").length > 0) {
          var option = $("input:checked");
          description = option.siblings('.description').find('strong').text();
          description = description.replace(':','');
          amount = option.data('amount');
          option.addClass('chosenoption');
        } else {
          alert('You have to choose an option!');
          return false
        }
      } else {
        $(this).addClass('chosenoption');
        handler.open({
          name: 'ToTheGig',
          description: description,
          amount: amount,
          shippingAddress: true,
          billingAddress: true
        });
      }
    });
    
    // Close Checkout on page navigation
    $(window).on('popstate', function() {
      handler.close();
    });
  });
};


function setData() {
  var _this = $('.chosenoption')
  var amount = _this.data('amount');
  var description = _this.data('description');
  var p_id = _this.data('option');
  var founder = _this.data('special')
  var information = {
    amount: amount,
    description: description,
    p_id: p_id,
    founder: founder
  };
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

function scalablepressCall(redirectTo, size, gender, address) {
  if (address) {
    $.ajax({
            url: '/preorder/scalablepresscall',
            type: "POST",
            dataType: "html",
            data: {
              size: size,
              gender: gender,
              address: address
            },
            success: function(data) {
              checkResponse(data);
            }
    });
  }
};

function checkResponse(data) {
  var colors = [];
  var eachToken = [];
  data = JSON.parse(data);
  $.each(data, function(i, _this) {
    if (_this['status'] == 'ok') {
      colors.push(_this['color_hex']);
      eachToken.push(_this['orderToken']);
    } else {
      switch (_this['type']) {
      case 'address':
        $('#alert_' + _this['field']).show();
        $('#alert_shipping').show(400, 'swing', setTimeout(function() {
          $('#alert_shipping').hide(400, 'swing');
          $('#alert_' + _this['field']).hide();
        }, 3000));
        return false;
      case 'product':
        $('#alert_not_available').show(400, 'swing', setTimeout(function() {
          $('#alert_not_available').hide(400, 'swing');
        }, 6000));
        return false;
      }
    }
  });
  if (colors.length > 0) {
    showColors(colors, eachToken);
  }
};

function showColors(colors, eachToken) {
  $.each(colors, function(i, _this) {
    $('#color_holder').children('.column-flex').prepend("<div class='color-choice' style='background-color: " + _this + "' data-choice='" + eachToken[i] + "'></div>");
    $('.color-choice').off('click').on('click', function() {
      var token = $(this).data('choice');
      scalablepressPlaceOrder(token);
    });
  });
  $('#submit_holder').hide(200, 'swing');
  $('#details_holder').hide(200, 'swing');
  $('#color_holder').show(400, 'swing');
};

function scalablepressPlaceOrder(token) {
  $.ajax({
          url: '/preorder/scalablepressorder',
          type: "POST",
          dataType: "html",
          data: {
            token: token
          },
          success: function(data) {
            window.location.href = data;
          }
  });
};

function selectDetails(data, founder) {
  data = JSON.parse(data);
  if (founder == "founder") {
    $.magnificPopup.open({
      items: {
        src: "#select_details"
      },
      type: 'inline',
      modal: true
    }, 0);
    
  	$(document).on('click', '.confirm_select_modal', function (e) {
      var size = $('select#size').val().toLowerCase();
      var gender = $('input[name=gender]:checked').val()
      if (gender) {
        gender = gender.toLowerCase();
      }
      if (size && gender) {
        //check_status = checkStateZip();
        scalablepressCall(data, size, gender, format_address(data));
      } else {
        $('#alert_no_selection').show(400, 'swing', setTimeout(function() {
          $('#alert_no_selection').hide(400, 'swing');
        }, 3000));
      }
  	});
    
  	$(document).on('click', '.close_select_modal', function (e) {
      $.magnificPopup.close();
  	});

  } else {
    window.location.href = data['path'];
  }
};

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
//This was used before//
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

$(document).ajaxStart(function(){
  $('.glass').show(400, 'swing', function() {
    $('.glass').spin(); 
  });
});
$(document).ajaxStop(function(){ 
  $('.glass').hide(400, 'swing', function() {
      $('.glassh').spin(false);  
  });
});
$(document).ready(ready);

