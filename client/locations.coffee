#
# (c) 2013 Kasper Souren
#


Locations = new Meteor.Collection 'locations'



Meteor.startup ->
  mapSize()
  $(window).resize ->
    mapSize()


mapSize = ->
  $('#map').height($(window).height() - 80)




@trashmap = new class
  constructor: ->
    markers = []
    Meteor.startup =>
      @createMap()

  createMap: ->
    document.markers = @markers = []
    map = @map = L.map "map",
      zoom: 12
      center: [51.5, -0.09]
      minZoom: 2
      maxZoom: 17
    L.tileLayer("http://{s}.tile.cloudmade.com/9c9b2bf2a30e47bcab503fa46901de36/997/256/{z}/{x}/{y}.png",
      attribution: "Map data &copy; <a href=\"http://openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"http://cloudmade.com/\">CloudMade</a>"
    ).addTo @map

    @mapMoved null
    @map.on 'moveend', (e) =>
      console.log this
      @mapMoved e

    self = @
    Meteor.autorun ->
      locations = Locations.find({}).fetch()
      _.each locations, (l) ->
        self.addMarkerLocation l

    popup = L.popup()
    @map.on 'dblclick', (e) =>
      console.log popup
      latlng = e.latlng
      popup.setLatLng latlng
      if Meteor.user()
        popup.setContent Template.addLocation()
      else
        popup.setContent 'Log in to add locations'
      popup.openOn @map

      $('#add-location').click (e) =>
        console.log e
        location =
          user: Meteor.userId()
          latlng: latlng
          description: $('#location-description').val()
          type: $('#location-type').val()
          rating: $('#location-rating').val()
          checked: $('#location-checked').val()
        console.log location
        Locations.insert location
        @addMarkerLocation location

    @setCurrentPosition()

  setCurrentPosition: ->
    navigator.geolocation.getCurrentPosition (location) =>
      lng = location.coords.longitude
      lat = location.coords.latitude
      Session.set 'latlng', [ lat, lng ]
      @map.setView [ lat, lng ], 12


  mapMoved: (e) ->
    console.log 'map moved', e


  addMarkerLocation: (l) =>
    name = l.description + ' ' + l.type
    bounds = @map.getBounds()
    console.log l
    if l.latlng?
      l.latlng = $.map l.latlng, parseFloat # contains crashes on strings
      if bounds.contains(l.latlng)
        marker_id = l.user + l.description
      # if not _.contains(_.map(@markers, (m) -> m.id), marker_id)
      icon = L.icon
        iconUrl: '/icons/' + l.type + '.png'
        iconSize: [ 50, 50 ] # size of the icon
        iconAnchor: [ 25, 25 ] # point of the icon which will correspond to marker's location
        popupAnchor: [ 0, -25 ] # point from which the popup should open relative to the iconAnchor

      marker = L.marker(l.latlng, { icon: icon }).addTo @map
      marker.id = marker_id
      text = '<div id="popup-description">' + l.description + '</div>' + l.type
      marker.bindPopup text
