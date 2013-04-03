fs = require 'fs'
request = require 'request'
csv = require 'csv'

eps = 1e-6

# 
# zoom = 14
# for x in [4615..4622]
#   for y in [6315..6319]
#     console.log "x: #{x} y: #{y}"
#     request "http://t3.transloc.com/stops/#{zoom}/#{x}/#{y}.json", (error, response, body) ->
#       if not error and response.statusCode is 200
#         console.log body
#       else
#         console.log response.statusCode

transloc_stops = JSON.parse(fs.readFileSync('transloc_stops.json').toString())

findTransLocStopId = (lat, lng) ->
  for stop in transloc_stops
    if Math.abs(lat-stop.position[0]) < eps and Math.abs(lng-stop.position[1]) < eps
      return stop.id
  return null

# Populate hoosbus stops
hoosbus_stops = {}

csv()
.from(fs.readFileSync('hoosbus_stops.txt').toString())
.on 'record', (row, index) ->
  return if index is 0
  stop_code = row[1]
  lat = row[3]
  lng = row[4]
  stopId = findTransLocStopId(lat, lng)
  if stopId?
    hoosbus_stops[stop_code] = stopId
.on 'end', ->
  console.log hoosbus_stops
  
  # Find the ones not matched. Have to manually add these to the map.
  for stop in transloc_stops
    found = false
    for k, v of hoosbus_stops
      if stop.id is v
        found = true
    if not found
      console.log stop.id
