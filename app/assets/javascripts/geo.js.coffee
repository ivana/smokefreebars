$ ->
  myOptions = {
    center: new google.maps.LatLng(45.81005400765967, 15.971031188964844),
    zoom: 13,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map document.getElementById('map_canvas'), myOptions

  $.get '/?format=json', (bars) ->
    mapBar(bar) for bar in bars

  mapBar = (bar) ->
    latlng = new google.maps.LatLng bar.lat, bar.lng

    marker = new google.maps.Marker {
      title: bar.name,
      map: map,
      animation: google.maps.Animation.DROP,
      position: latlng
    }

    infowindow = new google.maps.InfoWindow {
      content: '<div class=bubble><h2>' + bar.name + '</h2><p>' + bar.address + '</p></div>'
    }

    google.maps.event.addListener marker, 'click', ->
      infowindow.open(map, marker)

