$(function() {
  $(".pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
});

// For older jQuery versions...
// jQuery.ajaxSetup({ 
//   'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
// });