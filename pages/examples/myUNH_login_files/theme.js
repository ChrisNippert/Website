'use strict';

var secureAuth = secureAuth || {};

secureAuth.theme = (function () {
  var init = function () {
  };

  return {
    init: init
  };
}());

$(document).on('saReady', function() {
  secureAuth.theme.init();
});