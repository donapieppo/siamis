var update_wcount = function(el) {
  var words = el.val().trim().split(/\s+/ ).length;
  $('#wcount').html(words);
};

