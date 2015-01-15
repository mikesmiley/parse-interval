# Parse Interval

Parse time intervals of the form DD.HH:MM:SS.FFFFFFFFF

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
```

## Testing

```bash
$ npm test
```

## License

  [MIT](LICENSE)
