#
# TimeInterval handles time intervals in the format DD.HH:MM:SS.FFFFFFFFF
#
# This class transparently handles situations where the developer forgets to instantiate with the "new" keyword.
#
# Parsing a Time Interval string
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
  intervalRegex: ///
    ^(\d+)?.?  # 1: days, optional
    (\d{2}):   # 2: hours
    (\d{2}):   # 3: minutes
    (\d{2}).?  # 4: seconds
    (\d{0,9})? # 5: fractional seconds down to nanosecond, optional
  ///

  #
  # Constructor initializes values and parses a string argument if
  # provided.
  # Throws an Error for invalid string input
  #
  constructor: (i) ->
    # Handle the developer forgetting to use the "new" keyword
    return new TimeInterval i unless @ instanceof TimeInterval

    @days = @hours = @minutes = @seconds = @milliseconds = @nanoseconds = 0

    # parse if argument is string
    if typeof(i) is 'string'
      if i.length > 0
        @parse i
      else
        throw new Error("input is not a string")

  #
  # Function parses a string for Time Interval.
  # Throws Error for valid string input.
  #
  parse: (i) ->
    # save off original string
    @pristine = i
    ti = i.match @intervalRegex
    if ti
      @days = @convert ti[1]
      @hours = @convert ti[2]
      @minutes = @convert ti[3]
      @seconds = @convert ti[4]
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
  # Calculate the total number of hours represented by this time interval.
  #
  totalHours: ->
    @reflow()

    @days*24 + \
    @hours

  #
  # Calculate the total number of minutes represented by this time interval.
  #
  totalMinutes: ->
    @reflow()

    @days*1440 + \
    @hours*60 + \
    @minutes

  #
  # Calculate the total number of seconds represented by this time interval.
  #
  totalSeconds: ->
    @reflow()

    @days*86400 + \
    @hours*3600 + \
    @minutes*60 + \
    @seconds

  #
  # Calculate the total number of milliseconds represented by this time interval.
  #
  totalMilliseconds: ->
    @reflow()

    @days*86400000 + \
    @hours*3600000 + \
    @minutes*60000 + \
    @seconds*1000 + \
    @milliseconds

  #
  # Calculate the total number of nanoseconds represented by this time interval.
  #
  totalNanoseconds: ->
    @reflow()

    @days*864e11 + \
    @hours*36e11 + \
    @minutes*6e10 + \
    @seconds*1e9 + \
    @nanoseconds

  #
  # Function renders TimeInterval to a string in Time Interval format.
  #
  toString: ->
    @reflow()

    ret = ""
    if @days
      ret += "#{@days}."
    # render main part. single digit values for hours, minutes, and seconds should be zero-padded
    ret += "#{if @hours <= 9 then '0' else ''}#{@hours}:\
            #{if @minutes <= 9 then '0' else ''}#{@minutes}:\
            #{if @seconds <= 9 then '0' else ''}#{@seconds}"
    # prefer nanoseconds, but use milliseconds if set
    if @nanoseconds > 1e3
      ret += ".#{@nanoseconds}"
    else if @milliseconds
      ret += ".#{@milliseconds}"
    return ret

  #
  # Reflow the numbers.
  #
  reflow: ->
    # Reflow overflowing nanoseconds
    if @nanoseconds > 1e3
      if @nanoseconds >= 1e9
        @seconds = Math.floor(@nanoseconds / 1e9)
        @nanoseconds = @nanoseconds % 1e9
    else
      if @milliseconds >= 1e3
        @seconds = Math.floor(@milliseconds / 1e3)
        @milliseconds = @milliseconds % 1e3
    # Reflow overflowing seconds
    if @seconds >= 60
      @minutes += Math.floor(@seconds / 60)
      @seconds = @seconds % 60
    # Reflow overflowing minutes
    if @minutes >= 60
      @hours += Math.floor(@minutes / 60)
      @minutes = @minutes % 60
    # Reflow overflowing hours
    if @hours >= 24
      @days += Math.floor(@hours / 24)
      @hours = @hours % 24

#
# Exports
#
module.exports = TimeInterval
