/** @jsx React.DOM */

$('.locations.show').ready(function(e) {

  startReact();

  var $arrow = $('#location-arrow-up'),
      $pen = $('#location-write-icon'),
      $body = $('html,body'),
      $formContainer = $("#location-new-post"),
      $closeIcon = $(".close-icon");

  $arrow.click(function(event) {
    event.preventDefault();
    scrollToY(0, $body);
  });

  $pen.click(function(event) {
    event.preventDefault();
    togglePostForm($formContainer, $body);
  });

  $closeIcon.click(function(event) {
    event.preventDefault();
    handleCloseIconClick(event.target);
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

var togglePostForm = function($formContainer, $body) {
  if (typeof $formContainer === 'undefined') {
    $formContainer = $("#location-new-post");
  }

  $formContainer.toggle(500, function() {
    var y = $formContainer.offset().top;
    if ($formContainer.is(':visible')) {
      scrollToY(y - 100, $body);
    }
    else {
      scrollToY(0, $body);
    }
  });
};

var handleCloseIconClick = function(icon) {
  $(icon).closest('.closable-container').hide(500);
};

var getText = function($input) {
  return $input.val().trim();
};

var getNewPostInput = function(form) {
    var gender = $("#new-post-gender").val();
    var hair = $("#new-post-hair").val();
    var location = getText($("#new-post-location"));
    var message = getText($("#new-post-message"));

    if (validateNewPostInput(location, message)) {
      return {
        post: {
          gender: gender,
          hair: hair,
          spotted_at: location,
          content: message
        }
      };
    }
    else {
      return false;
    }
};

var validateNewPostInput = function(location, message) {
  if (location && message) {
    return true;
  }
  else {
    if (!location) {
      $("#new-post-location-requirement").fadeIn(300);
    }
    if (!message) {
      $("#new-post-message-requirement").fadeIn(300);
    }
    return false;
  }
};

var enableForm = function(form) {
  var $inputs = getEnableableInputs(form);
  $inputs.prop('disabled', false);
};

var disableForm = function(form) {
  var $inputs = getEnableableInputs(form);
  $inputs.prop('disabled', true);
};

var resetForm = function(form) {
  var $inputs = $(form).find('input[type=text],textarea,select');
  $inputs.val('');
};

var getEnableableInputs = function(form) {
  return $(form).find('input[type=text],input[type=submit],textarea,select');
};

var startReact = function() {
  var path = window.location.pathname + "/posts";
  var container = document.getElementById('location-posts');
  var interval = 10000;  // 10 seconds, interval of polling requests
  var batch = 15;       // increment of posts to load

  React.renderComponent(
    <LocationPosts path={path} pollInterval={interval} batchSize={batch} />,
    container
  )
};