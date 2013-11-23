$(document).ready(function () {
  $('#checkout').submit(function (e) {
    $('#stripe_errors').hide()
    e.preventDefault();
    var _this = this
    Stripe.card.createToken({
      number:         $('#card_number').val().replace(/ /g, ''),
      exp_month:      $('#expires').val().split('/')[0],
      exp_year:       $('#expires').val().split('/')[1],
      cvc:            $('#cvv').val()
    }, function (error, result) {
      if (error == 200) {
        $('#stripe_token').val(result.id);
        console.log('stripe token added')
        _this.submit();
      }
      else {
        //error
        $('#stripe_errors').show()
        return false;
      }
    });
  });
});
