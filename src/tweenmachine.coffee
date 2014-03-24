###

TweenMachine
@property {Number | Array} start
@property {Number | Array} end
@property {TweenMachine.Easing} easing
@property {TweenMachine.Interpolation} interpolation

###

class @TweenMachine

  # http://stackoverflow.com/a/1830844/652765
  isNumber = (candidate) ->
    return !isNaN(parseFloat(candidate)) and isFinite(candidate)

  clamp = (lower, upper, value) ->
    return lower if value < lower
    return upper if value > upper
    return value

  @tweens = []
  @clear = -> TweenMachine.tweens.length = 0

  constructor: (@start, @end) ->

    @type = 'Numeric' if isNumber(@start) and isNumber(@end)
    @type = 'Array' if Array.isArray(@start) and Array.isArray(@end)

    unless @type? then throw new Error 'Must provide either numeric or Array start and end values.'

    @$id = TweenMachine.tweens.length
    @easer = TweenMachine.easings.Linear.None
    @interpolator = TweenMachine.interpolations.Linear

    TweenMachine.tweens.push this
    return this

  easing: (name) ->
    [category, type] = name.split('.')
    @easer = TweenMachine.easings[category][type]
    return this

  interpolation: (name) ->
    @interpolator = TweenMachine.interpolations[name]
    return this

  at: (progress) ->
    progress = clamp(0, 1, progress)

    switch @type
      when 'Numeric' then @start + (@end - @start) * @easer(progress)
      when 'Array' then @interpolator @end, @easer(progress)
