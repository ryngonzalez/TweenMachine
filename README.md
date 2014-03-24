![TweenMachine](http://i.imgur.com/183j75n.png)

[Tween.js](https://github.com/sole/tween.js/) provides wonderful support for tweening between states over a duration of time. But what if you wanted to do
a tween based on touch position over an area, or the percentage of a download completed? TweenMachine decouples the tweening logic of Tween.js from the depency of time. Use the same easing & interpolation functions available to Tween.js to build reversible, touch and movement dependent animation. 

## Usage

To start, create a new TweenMachine:

```javascript

var tween = new TweenMachine(0, 100);

tween.easing('Bounce.InOut')
     .interpolation('Bezier')

var valueAtZeroPercent = tween.get(0.0),
    valueAtFiftyPercent = tween.get(0.5),
    valueAtHundredPercent = tween.get(1);

```

## Easing Functions
Based off of [Robert Penner's Easing Functions](http://www.robertpenner.com/easing/).

![](http://i.imgur.com/e8Ocshv.png)
