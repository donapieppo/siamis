var ok_modal_close_policy = false;
var reload_on_modal_close = false;

var update_wcount = function(el) {
  var words = el.val().trim().split(/\s+/).length;
  // boh 
  if (el.val().trim() == "") { words = 0 };
  $('#wcount').html(words);
};

function update_interests_highlight() {
  $(".interested").removeClass("interested");
  $.getJSON("/siamis/interests/session_ids", function( data ) {
    data.interests.forEach( function(el) {
      cs_id = el.conference_session_id + "-" + el.part;
      $("#" + cs_id).addClass("interested");
    }); 
  });
}

$('document').ready(function() {
  $(".condensed_panel .panel-body").hide();
  $(".condensed_panel .panel-footer").hide();
  $(".condensed_panel .panel-heading").click(function() {
    $(this).siblings(".panel-body").toggle();
    $(this).siblings(".panel-footer").toggle();
  });

});
