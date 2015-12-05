
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
                  window.location.href = data;
              }
      });
    }
  });
  
  $('.payable').unbind().on('click', function(e) {
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

};


function setData() {
  var _this = $('.chosenoption')
  var amount = _this.data('amount');
  var description = _this.data('description');
  var p_id = _this.data('option');
  var information = {
    amount: amount,
    description: description,
    p_id: p_id
  };
  return information;
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


$(document).on('page:change', ready);

