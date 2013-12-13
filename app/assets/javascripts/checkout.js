$(document).ready(function () {
  $('#checkout').submit(function (e) {
    $('#payment_errors').hide();
    e.preventDefault();
    var _this = this;
    Stripe.card.createToken({
      number:         $('#card_number').val().replace(/ /g, ''),
      exp_month:      $('#expires').val().split('/')[0],
      exp_year:       $('#expires').val().split('/')[1],
      cvc:            $('#cvv').val()
    }, function (error, response) {
      if (error == 200) {
        $('#stripe_token').val(response.id);
        console.log('stripe token added');
        _this.submit();
      }
      else {
        //error
        if (response && response.error && response.error.message) {
         $('#payment_errors_info').text(response.error.message);
        } else {
          $('#payment_errors_info').text('');
        }
        $('#payment_errors').show();
        return false;
      }
    });
  });
});