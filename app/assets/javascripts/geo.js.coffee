$ ->
  myOptions = {
    center: new google.maps.LatLng(45.812873, 15.966025),
    zoom: 14,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions)
