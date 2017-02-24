$(document).on('turbolinks:load', function() {
  if( !$('.flash-messages').is(':empty') ) {
    setTimeout(function() {
      $('.flash-messages').slideUp(1000);
    }, 3000);
  }
});
