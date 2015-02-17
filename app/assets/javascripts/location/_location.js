$('.locations.show').ready(function(e) {

  startReact();

  var $arrow = $('#location-arrow-up'),
      $pen = $('#location-write-icon'),
      $body = $('html,body');

  $arrow.click(function(event) {
    event.preventDefault();
    scrollToY(0, $body);
  });

  $pen.click(function(event) {
    event.preventDefault();
    // IMPLEMENT SHOWING FORM
  });
});

var scrollToY = function(y, $body) {
  if (typeof $body === 'undefined') {
    $body = $('html,body');
  }

  $body.animate({
    scrollTop: y
  }, 750);
  return false;
};

var startReact = function() {
  var $path = window.location.pathname;
};

