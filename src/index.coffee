
TimeInterval = require './time-interval'

#
# Parse an interval string using a new TimeInterval object.
#
exports.parse = (interval) ->
  new TimeInterval interval

#
# Return a blank TimeInterval object for assigning values and .toString() functionality.
#
exports.blank = ->
  new TimeInterval()
