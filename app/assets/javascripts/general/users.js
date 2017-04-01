//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.

$(function(){
  var autocomplete;
  if($("#generic-autocomplete").length > 0) {
    autocomplete = new google.maps.places.Autocomplete(
      (document.getElementById('generic-autocomplete')),
      { types: ['geocode'] }
    );
    google.maps.event.addListener(autocomplete, 'place_changed', function(e) {
      var place = autocomplete.getPlace();
      document.getElementById('lat').value = place.geometry.location.lat();
      document.getElementById('lng').value = place.geometry.location.lng();
    });

    $('#generic-autocomplete').bind('keypress', function(e) {
      if ((e.keyCode || e.which) == 13) {
        e.preventDefault();
      }
    });
  }
});
