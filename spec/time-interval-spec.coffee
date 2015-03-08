#
# Unit tests for TimeInterval
#
describe "The parse-interval module", ->

  pi = require('../')

  it "should create blank interval on create()", ->
    ti = pi.create()
    expect(ti.toString()).toBe "00:00:00"


  it "should reflow overflowing minutes", ->
    ti = pi.create()
    ti.seconds = 93784
    expect(ti.toString()).toBe "1.02:03:04"

  it "should reflow overflowing seconds", ->
    ti = pi.create()
    ti.seconds = 93784
    expect(ti.toString()).toBe "1.02:03:04"

  it "should reflow overflowing milliseconds", ->
    ti = pi.create()
    ti.milliseconds = 93784123
    expect(ti.toString()).toBe "1.02:03:04.123"

  it "should reflow overflowing nanoseconds", ->
    ti = pi.create()
    ti.nanoseconds = 93784123456789
    expect(ti.toString()).toBe "1.02:03:04.123456789"

  it "should parse 1.02:03:04.123456789", ->
    ti = pi.parse "1.02:03:04.123456789"
    expect(ti.days).toBe 1
    expect(ti.hours).toBe 2
    expect(ti.minutes).toBe 3
    expect(ti.seconds).toBe 4
    expect(ti.milliseconds).toBe 123
    expect(ti.nanoseconds).toBe 123456789

  it "should parse 02:03:04.123456789", ->
    ti = pi.parse "02:03:04.123456789"
    expect(ti.days).toBe 0
    expect(ti.hours).toBe 2
    expect(ti.minutes).toBe 3
    expect(ti.seconds).toBe 4
    expect(ti.milliseconds).toBe 123
    expect(ti.nanoseconds).toBe 123456789

  it "should parse 02:03:04", ->
    ti = pi.parse "02:03:04"
    expect(ti.days).toBe 0
    expect(ti.hours).toBe 2
    expect(ti.minutes).toBe 3
    expect(ti.seconds).toBe 4
    expect(ti.milliseconds).toBe 0
    expect(ti.nanoseconds).toBe 0

  it "should parse 02:03:04.12345", ->
    ti = pi.parse "02:03:04.12345"
    expect(ti.days).toBe 0
    expect(ti.hours).toBe 2
    expect(ti.minutes).toBe 3
    expect(ti.seconds).toBe 4
    expect(ti.milliseconds).toBe 123
    expect(ti.nanoseconds).toBe 123450000

  it "should parse 2:03:04", ->
    ti = pi.parse "02:03:04"
    expect(ti.days).toBe 0
    expect(ti.hours).toBe 2
    expect(ti.minutes).toBe 3
    expect(ti.seconds).toBe 4
    expect(ti.milliseconds).toBe 0
    expect(ti.nanoseconds).toBe 0

  it "should throw exception for 2:03", ->
    x = ->
      pi.parse "2:03"
    expect(x).toThrow()

  it "should throw exception for empty string constructor input", ->
    x = ->
      pi.parse ""
    expect(x).toThrow()

  it "should provide total hours", ->
    ti = pi.parse "1.02:03:04.123456789"
    expect(ti.totalHours()).toBe 26

  it "should provide total minutes", ->
    ti = pi.parse "1.02:03:04.123456789"
    expect(ti.totalMinutes()).toBe 1563

  it "should provide total seconds", ->
    ti = pi.parse "1.02:03:04.123456789"
    expect(ti.totalSeconds()).toBe 93784

  it "should provide total milliseconds", ->
    ti = pi.parse "1.02:03:04.123456789"
    expect(ti.totalMilliseconds()).toBe 93784123

  it "should provide total nanoseconds", ->
    ti = pi.parse "1.02:03:04.123456789"
    expect(ti.totalNanoseconds()).toBe 93784123456789

  it "should properly render to string with milliseconds", ->
    ti = pi.create()
    ti.days = 1
    ti.hours = 2
    ti.minutes = 3
    ti.seconds = 4
    ti.milliseconds = 123
    expect(ti.toString()).toBe "1.02:03:04.123"

  it "should properly render to string with nanoseconds", ->
    ti = pi.create()
    ti.days = 1
    ti.hours = 2
    ti.minutes = 3
    ti.seconds = 4
    ti.nanoseconds = 123456789
    expect(ti.toString()).toBe "1.02:03:04.123456789"
