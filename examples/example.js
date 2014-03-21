(function(){

  var tween = new TweenMachine(0, 100);

  var valueAtZeroPercent = tween.get(0.0),
      valueAtFiftyPercent = tween.get(0.5),
      valueAtHundredPercent = tween.get(1);

})()
