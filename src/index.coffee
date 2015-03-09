
TimeInterval = require './time-interval'

#
# Parse an interval string using a new TimeInterval object.
#
exports.parse = (interval) ->
  new TimeInterval interval

#
# Return a new TimeInterval object for assigning values and .toString() functionality.
#
exports.create = ->
  new TimeInterval()

#
# Return the system uptime as a TimeInterval object ready to be stringified.
#
exports.uptime = ->
  os = require 'os'
  ti = new TimeInterval()
  ti.seconds = os.uptime()
  return ti
