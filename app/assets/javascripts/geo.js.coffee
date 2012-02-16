$ ->
  myOptions = {
    center: new google.maps.LatLng(45.800432, 15.979458),
    zoom: 12,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map document.getElementById('map'), myOptions

  # AJAX #

  # map bars
  $.get '/?format=json', (bars) ->
    markOnMap(bar) for bar in bars

  # EVENTS #

  # locate me
  $('#locate').on 'click', ->
    # try html5 geolocation
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) ->
        pin position
      , (error) -> # handle error
        alert 'Error: The Geolocation service failed.'
        console.log error.message if console
    false

  # FUNCTIONS, HELPERS #

  prevInfoWin = null # infowindow reference, for closing the previously opened one

  # pin a bar on map (map bars)
  markOnMap = (bar) ->
    latlng = new google.maps.LatLng bar.lat, bar.lng

    marker = new google.maps.Marker {
      title: bar.name,
      map: map,
      position: latlng,
      animation: google.maps.Animation.DROP
    }

    infowindow = new google.maps.InfoWindow {
      content: '<div class=bubble><h2>' + bar.name + '</h2><p>' + bar.address + '</p></div>'
    }

    google.maps.event.addListener marker, 'click', -> # on marker click
      prevInfoWin.close() if prevInfoWin
      infowindow.open map, marker
      prevInfoWin = infowindow

    google.maps.event.addDomListener document.getElementById('b_' + bar.id), 'click', -> # on list link click
      prevInfoWin.close() if prevInfoWin
      infowindow.open map, marker
      map.setCenter latlng
      prevInfoWin = infowindow

  # pin position (locate me)
  pin = (position) ->
    pos = new google.maps.LatLng position.coords.latitude, position.coords.longitude

    # custom pin color
    pinImage = new google.maps.MarkerImage "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%20|dddddd", new google.maps.Size(21, 34), new google.maps.Point(0,0), new google.maps.Point(10, 34)
    pinShadow = new google.maps.MarkerImage "http://chart.apis.google.com/chart?chst=d_map_pin_shadow", new google.maps.Size(40, 37), new google.maps.Point(0, 0), new google.maps.Point(12, 35)

    marker = new google.maps.Marker {
      title: 'Your are here',
      map: map,
      position: pos,
      icon: pinImage,
      shadow: pinShadow,
      animation: google.maps.Animation.DROP
    }
    map.setCenter pos

