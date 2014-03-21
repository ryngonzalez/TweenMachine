class ProgressProvider

  BOUNDS =
    lower: 0.0
    upper: 1.0

  constructor: ->
    @progress = 0

  get: ->
    throw new Error 'Progress must be between 0.0 and 1.0' unless @inBounds()
    @progress

  inBounds: ->
    BOUNDS.lower <= @progress <= BOUNDS.upper


###
tween = new TweenMachine(currentPosition, endPosition)
###
