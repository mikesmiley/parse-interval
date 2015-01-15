#
# Class to handle time intervals in the format DD.HH:MM:SS.FFFFFFFFF
#
# @note This class transparently handles situations where the developer forgets to instantiate with the "new" keyword.
#
# @example Parsing a Time Interval string
#   pi = require 'parse-interval'
#   ti = pi.parse "1.02:03:04.123456789"
#   console.log "Days:         #{ti.days}"
#   console.log "Hours:        #{ti.hours}"
#   console.log "Minutes:      #{ti.minutes}"
#   console.log "Seconds:      #{ti.seconds}"
#   console.log "Milliseconds: #{ti.milliseconds}"
#   console.log "Nanoseconds:  #{ti.nanoseconds}"
#
class TimeInterval
  # Regular Expression to match Time Interval string format
  # @note See code for comments on regex captures
  intervalRegex: ///
    ^(\d)?.?   # 1: days, optional
    (\d{2}):   # 2: hours
    (\d{2}):   # 3: minutes
    (\d{2}).?  # 4: seconds
    (\d{0,9})? # 5: fractional seconds down to nanosecond, optional
  ///

  # @property [Integer] The number of days
  days: undefined
  # @property [Integer] The number of hours
  hours: undefined
  # @property [Integer] The number of minutes
  minutes: undefined
  # @property [Integer] The number of seconds
  seconds: undefined
  # @property [Integer] The number of milliseconds
  milliseconds: undefined
  # @property [Integer] The number of nanoseconds
  nanoseconds: undefined
  # @property [String] An un-modified copy of the input string
  pristine: undefined

  #
  # Constructor initializes values and parses a string argument if
  # provided.
  # @throw [Error] for invalid string input
  #
  constructor: (i) ->
    # handle the developer forgetting to use the "new" keyword
    return new TimeInterval i unless @ instanceof TimeInterval

    # parse if argument is string
    if typeof(i) is 'string'
      if i
        @parse i
      else
        throw new Error("input does not contain valid TimeInterval string")

  #
  # Function parses a string for Time Interval.
  # @throw [Error] for invalid string input
  #
  parse: (i) ->
    # save off original
    @pristine = i
    ti = i.match @intervalRegex
    if ti
      @days = @convert ti[1]
      @hours = @convert ti[2]
      @minutes = @convert ti[3]
      @seconds = @convert ti[4]
      # convert any fractional to milliseconds
      # since that is JavaScript's preferred resolution
      @milliseconds = @convert ti[5], (val) ->
        Math.round(parseInt(val) * Math.pow(10, 3 - val.length))
      @nanoseconds = @convert ti[5], (val) ->
        Math.round(parseInt(val) * Math.pow(10, 9 - val.length))
    else
      throw new Error("input does not contain valid TimeInterval string")

  #
  # Function to convert string value into a TimeInterval-compatible member.
  # If a callback is provided, it will be used for the conversion.
  # Undefined, null, and empty strings are converted to zero.
  # @param s [String] The string to parse and convert
  # @param callback [Function] Optional function to use for conversion
  #
  convert: (s, callback) ->
    if s and s.length > 0
      if callback
        callback s
      else
        parseInt s
    else # convert null/undefined/'' to zero value
      0

  #
  # Function returns the total number of milliseconds represented by the current
  # TimeInterval.
  # @return [Integer] total milliseconds
  #
  totalMilliseconds: ->
    @days*86400000 + \
    @hours*3600000 + \
    @minutes*60000 + \
    @seconds*1000 + \
    @milliseconds

  #
  # Function returns the total number of nanoseconds represented by the current
  # TimeInterval.
  # @return [Integer] total nanoseconds
  #
  totalNanoseconds: ->
    @days*864e11 + \
    @hours*36e11 + \
    @minutes*6e10 + \
    @seconds*1e9 + \
    @nanoseconds

  #
  # Function renders TimeInterval to a string in Time Interval format.
  # @return [String] String representing current TimeInterval properties.
  #
  toString: ->
    ret = ""
    if @days
      ret += "#{@days}."
    # render main part. single digit values for hours, minutes, and seconds should be zero-padded
    ret += "#{'0' if @hours <= 9}#{@hours}:\
            #{'0' if @minutes <= 9}#{@minutes}:\
            #{'0' if @seconds <= 9}#{@seconds}"
    # prefer nanoseconds, but use milliseconds if set
    if @nanoseconds
      ret += ".#{@nanoseconds}"
    else if @milliseconds
      ret += ".#{@milliseconds}"
    return ret

#
# Exports
#
module.exports = TimeInterval
