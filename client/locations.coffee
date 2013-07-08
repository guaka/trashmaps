#
# (c) 2013 Kasper Souren
#



Meteor.startup ->
  mapSize()
  $(window).resize ->
    mapSize()

mapSize = ->
  $('#map').height($(window).height() - 80)




document.evermap = evermap = new class
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


    @setCurrentPosition()

    console.log this
    @mapMoved null
    @map.on 'moveend', (e) =>
      console.log this
      @mapMoved e

    popup = L.popup()
    @map.on 'click', (e) =>
      console.log popup
      popup.setLatLng e.latlng
      if Meteor.user()
        popup.setContent 'Add new trash find <br />
    <table>
      <tr><th>description</th><td><input type="text" /></td></tr>
      <tr><th>rating</th><td>rating</td></tr>
      <tr><th>last checked</th></td>when</td></tr>
    </table>'

      else
        popup.setContent 'Log in to add locations'
      popup.openOn @map

  setCurrentPosition: ->
    navigator.geolocation.getCurrentPosition (location) =>
      lng = location.coords.longitude
      lat = location.coords.latitude
      Session.set 'latlng', [ lat, lng ]
      @map.setView [ lat, lng ], 12


  mapMoved: (e) ->
    console.log 'map moved', e



