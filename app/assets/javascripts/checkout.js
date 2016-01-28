
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

function selectDetails(data, founder) {
  if (founder == "founder") {
    $.magnificPopup.open({
      items: {
        src: "#select_details"
      },
      type: 'inline',
      modal: true
    }, 0);
  	$(document).on('click', '.close_select_modal', function (e) {
      var size = $('select#size').val();
      var gender = $('input[name=gender]:checked').val();
      if (size && gender) {
        $.magnificPopup.close();
        printfulCall(data);
      } else {
        $('#alert_no_selection').show(400, 'swing', setTimeout(function() {
          $('#alert_no_selection').hide(400, 'swing');
        }, 3000));
      }
  	});
  } else {
    window.location.href = data;
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


$(document).ready(ready);

