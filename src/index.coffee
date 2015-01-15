
TimeInterval = require './time-interval'

# parse function is the entry point
exports.parse = (interval) ->
  new TimeInterval interval
