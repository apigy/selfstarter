var ready = function() {
  preparePopup();
};

function preparePopup() {
  $('.pop_up').off('click');
  $('.pop_up').on('click', function() {
    var target = $(this).data('target');
    var open_pop = '#pop_up_' + target;
    $.magnificPopup.open({
      items: {
        src: open_pop
      },
      type: 'inline'
    }, 0);
  	$(document).on('click', '.popup-position-dismiss', function (e) {
  		$.magnificPopup.close();
  	});
  	$(document).on('click', '.popup-position-confirm', function (e) {
  		$.magnificPopup.close();
  	});
  }); 
};

$(document).ready(ready);
