fs = require 'fs'
request = require 'request'

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

s = fs.readFileSync('stops.json').toString()
console.log JSON.parse(s)