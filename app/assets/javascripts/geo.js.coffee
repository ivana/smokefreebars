$ ->
  myOptions = {
    center: new google.maps.LatLng(45.800432, 15.979458),
    zoom: 12,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map document.getElementById('map'), myOptions

  # map bars
  $.get '/?format=json', (bars) ->
    markOnMap(bar) for bar in bars

  # locate me
  $('#locate a').on 'click', ->
    # try html5 geolocation
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) ->
        pin position
        $.get '/?format=json', {coords: [position.coords.longitude, position.coords.latitude] }, (bars) ->
          if bars and bars.length
            reorder bars # replace existing html list with ordered by neareast
      , (error) -> # handle error
        # alert 'Error: The Geolocation service failed.'
        console.log error.message if console
    false

  # FUNCTIONS, HELPERS #

  prevInfoWin = null # infowindow reference, for closing the previously opened one

  # pin a bar on map (map bars)
  markOnMap = (bar) ->
    latlng = new google.maps.LatLng bar.coords.lat, bar.coords.lng

    marker = new google.maps.Marker {
      title: bar.name,
      map: map,
      position: latlng,
      animation: google.maps.Animation.DROP
    }

    infowindow = new google.maps.InfoWindow {
      content: "<div class=bubble><h2>#{bar.name}</h2><p>#{if bar.address then bar.address else ''}</p></div>"
    }

    google.maps.event.addListener marker, 'click', -> # on marker click
      prevInfoWin.close() if prevInfoWin
      infowindow.open map, marker
      prevInfoWin = infowindow

    $(document).on 'click', "#b_#{bar.id}", -> # on list link click
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
      title: 'You are here',
      map: map,
      position: pos,
      icon: pinImage,
      shadow: pinShadow,
      animation: google.maps.Animation.DROP
    }
    map.setCenter pos
    map.setZoom 15

  # some DOM manipulation to replace existing html list with ordered by neareast
  reorder = (bars) ->
    $('#bars').empty()
    append(bar) for bar in bars

  append = (bar) ->
    a = "<a href='/#map' class='name' id='b_#{bar.fsq_id}' title='Show on the map'>#{bar.name}</a>"
    addr = if bar.address then "<span class='address'>#{bar.address}</span>" else ""
    $('#bars').append "<li>#{a}#{addr}</li>"

