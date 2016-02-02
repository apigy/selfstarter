
var ready = function() {
  var handler = StripeCheckout.configure({
    key: 'pk_test_dFxDEPCmXwyF4ZhFNajbinzq',
    image: $('.imagelink').data('link'),
    locale: 'auto',
    token: function(token) {
      var paymentinfo = setData();
      $.ajax({
              url: '/preorder/order',
              type: "POST",
              dataType: "html",
              data: {
                token: token.id,
                email: token.email,
                paymentinfo
              },
              success: function(data) {
                selectDetails(data, paymentinfo.founder);
              }
      });
    }
  });
  
  $.each(['payable', 'button'], function() {
    $('.' + this).unbind().on('click', function(e) {
      e.preventDefault();
      var paymentinfo = setData();
      selectDetails("data", paymentinfo.founder);
    });
      /*
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
      }

      handler.open({
        name: 'ToTheGig',
        description: description,
        amount: amount
      });
      e.preventDefault();
    });
    
    // Close Checkout on page navigation
    $(window).on('popstate', function() {
      handler.close();
    });
    */
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
              console.log(data);
              checkResponse(data);
              //window.location.href = redirectTo;
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
      alert($(this).data('choice'));
    });
  });
  $('#details_holder').hide(200, 'swing');
  $('#color_holder').show(400, 'swing');
};

function selectDetails(data, founder) {
  //if (founder == "founder") {
    $.magnificPopup.open({
      items: {
        src: "#select_details"
      },
      type: 'inline',
      modal: true
    }, 0);
    
  	$(document).on('click', '.close_select_modal', function (e) {
      var size = $('select#size').val().toLowerCase();
      var gender = $('input[name=gender]:checked').val()
      if (gender) {
        gender = gender.toLowerCase();
      }
      if (size && gender) {
        check_status = checkStateZip();
        scalablepressCall(data, size, gender, check_status);
      } else {
        $('#alert_no_selection').show(400, 'swing', setTimeout(function() {
          $('#alert_no_selection').hide(400, 'swing');
        }, 3000));
      }
  	});
    /*
    $(document).on('click', '.submit_modal', function (e) {
     $(".color-choice").each( function() {
       alert($(this).data('choice'));
     }); 
    });
    */
    //} else {
    //window.location.href = data;
    //}
};

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

