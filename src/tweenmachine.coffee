
class TweenMachine

  # http://byronsalau.com/blog/how-to-create-a-guid-uuid-in-javascript/
  generateId = ->
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
        r = (Math.random() * 16) | 0 
        v = if c is 'x' then r else (r & 0x3 | 0x8)
        return v.toString(16)

  # http://stackoverflow.com/a/1830844/652765
  isNumber = (candidate) ->
    return !isNaN(parseFloat(candidate)) and isFinite(candidate)

  @tweens: []
  
  @all: ->
    @tweens

  constructor: (@start, @end, @easing, @interpolation) ->

    unless isNumber @start and isNumber @end
      throw new Error 'Must provide numeric start and end values'

    @easing or= TweenMachine.easings.Linear.None
    @interpolation or= TweenMachine.interpolations.Linear
    @$id = generateId()

    TweenMachine.tweens.push this
    return this

  at: (progress) ->
    @interpolation @end, @easing(progress)
