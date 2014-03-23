###

TweenMachine
@property {Number | Array} start
@property {Number | Array} end
@property {TweenMachine.Easing} easing
@property {TweenMachine.Interpolation} interpolation

###

class @TweenMachine

  # http://byronsalau.com/blog/how-to-create-a-guid-uuid-in-javascript/
  generateId = ->
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
        r = (Math.random() * 16) | 0 
        v = if c is 'x' then r else (r & 0x3 | 0x8)
        return v.toString(16)

  # http://stackoverflow.com/a/1830844/652765
  isNumber = (candidate) ->
    return !isNaN(parseFloat(candidate)) and isFinite(candidate)

  clamp = (lower, upper, value) ->
    if value < lower 
      lower 
    else if value > upper
      upper
    else 
      value

  @tweens: {}

  @clear: ->
    TweenMachine.tweens.length = 0
  
  ProgressFunctions =

    Numeric: (progress) ->
      @start + (@end - @start) * @easingFunction(progress)

    Array: (progress) ->
      @interpolationFunction @end, @easingFunction(progress)

  constructor: (@start, @end, @easingFunction, @interpolationFunction) ->

    if isNumber(@start) and isNumber(@end)
      @type = 'Numeric'
    else if Array.isArray(@start) and Array.isArray(@end)
      @type = 'Array'
    else
      throw new Error 'Must provide either numeric or Array start and end values.'

    @easingFunction or= TweenMachine.easings.Linear.None
    @interpolationFunction or= TweenMachine.interpolations.Linear
    @$id = generateId()

    TweenMachine.tweens[@$id] = this
    return this

  easing: (name) ->
    [category, type] = name.split('.')
    @easingFunction = TweenMachine.easings[category][type]
    this

  interpolation: (name) ->
    @interpolationFunction = TweenMachine.interpolations[name]
    this

  at: (progress) ->
    progress = clamp(0, 1, progress)
    ProgressFunctions[@type].bind(this)(progress)
