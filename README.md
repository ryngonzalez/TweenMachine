# TweenMachine
[Tween.js](https://github.com/sole/tween.js/) provides wonderful support for
tweening between states while over a set duration of time. But what if you
wanted to do a tween based on touch position over and area, or the percentage
of a download completed? TweenMachine decouples the tweening logic of Tween.js
from depencies of time.

# Usage

To start, create a new TweenMachine:

```javascript

var tween = new TweenMachine(0, 100);

var valueAtZeroPercent = tween.get(0.0),
    valueAtFiftyPercent = tween.get(0.5),
    valueAtHundredPercent = tween.get(1);

```
