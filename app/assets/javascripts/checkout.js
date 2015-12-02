
var ready = function() {
  $('#checkout').on('submit', function (e) {
    $('#stripe_errors').hide();
    e.preventDefault();
    var _this = this;
    Stripe.card.createToken({
      number:         $('#card_number').val().replace(/ /g, ''),
      exp_month:      $('#expires').val().split('/')[0],
      exp_year:       $('#expires').val().split('/')[1],
      cvc:            $('#cvv').val()
    }, function (error, result) {
      if (error == 200) {
        $('#stripe_token').val(result.id);
        //for debug if you want::::: console.log('stripe token added');
        _this.submit();
      }
      else {
        //error
        $('#stripe_errors').show();
        //for debug if you want::::: console.log('error ' + error + ' result: ' + JSON.stringify(result, null, 4));
        return false;
      }
    });
  });
};

//$(document).ready(ready);
$(document).on('page:change', ready);

