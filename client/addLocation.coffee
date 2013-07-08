
locationTypes = [
  'supermarket'
  'market'
  'shop'
  'random'
]

ratingLevel = [
  'excellent'
  'good'
  'okay'
  'mediocre'
  'bad'
]

Template.addLocation.locationTypes = ->
  _.map locationTypes, (t) ->
    type: t


Template.addLocation.ratingLevel = ->
  _.map ratingLevel, (t) ->
    level: t


