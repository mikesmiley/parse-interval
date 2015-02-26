# Parse Interval

Parse time intervals of the form DD.HH:MM:SS.FFFFFFFFF

The days and fractional second fields are optional. Fractional seconds can range from 1 to 9 digit accuracy.

## Installation

```bash
$ npm install parse-interval
```

## Usage

```coffee
pi = require 'parse-interval'

ti = pi.parse "1.02:03:04.123456789"
console.log "Days:         #{ti.days}"
console.log "Hours:        #{ti.hours}"
console.log "Minutes:      #{ti.minutes}"
console.log "Seconds:      #{ti.seconds}"
console.log "Milliseconds: #{ti.milliseconds}"
console.log "Nanoseconds:  #{ti.nanoseconds}"

# use totalMilliseconds() to help set intervals
setInterval ->
  console.log "hello world"
, ti.totalMilliseconds()
```

Total nanoseconds is also available:
```coffee
ti.totalNanoseconds()
```

Parse-interval also has .toString() functionality:

```coffee
ti = pi.blank()
ti.days = 1
ti.hours = 2
ti.minutes = 3
ti.seconds = 4
ti.milliseconds = 123
ti.toString()

> "1.02:03:04.123"
```

## Testing

```bash
$ npm test
```

## License

  [MIT](LICENSE)
