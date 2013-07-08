Locations = new Meteor.Collection 'locations'


Locations.allow
  insert: ->
    true
