var update_wcount = function(el) {
  var words = el.val().trim().split(/\s+/).length;
  // boh 
  if (el.val().trim() == "") { words = 0 };
  $('#wcount').html(words);
};

$('document').ready(function() {
  $(".condensed_panel .panel-body").hide();
  $(".condensed_panel .panel-heading").click(function() {
    $(this).next(".panel-body").toggle();
  });
});
