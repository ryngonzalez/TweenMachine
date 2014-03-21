utils =
  Linear: (p0, p1, t) ->
    (p1 - p0) * t + p0

  Bernstein: (n, i) ->
    fc = @Factorial
    fc(n) / fc(i) / fc(n - i)

  Factorial: do (a = [1]) ->
    (n) ->
      s = 1
      i = undefined
      return a[n]  if a[n]
      i = n
      while i > 1
        s *= i
        i--
      a[n] = s

  CatmullRom: (p0, p1, p2, p3, t) ->
    v0 = (p2 - p0) * 0.5
    v1 = (p3 - p1) * 0.5
    t2 = t * t
    t3 = t * t2
    (2 * p1 - 2 * p2 + v0 + v1) * t3 + (-3 * p1 + 3 * p2 - 2 * v0 - v1) * t2 + v0 * t + p1

@TweenMachine.interpolations =
  Linear: (v, k) ->
    m = v.length - 1
    f = m * k
    i = Math.floor(f)
    fn = utils.Linear
    return fn(v[0], v[1], f)  if k < 0
    return fn(v[m], v[m - 1], m - f)  if k > 1
    fn v[i], v[(if i + 1 > m then m else i + 1)], f - i

  Bezier: (v, k) ->
    b = 0
    n = v.length - 1
    pw = Math.pow
    bn = utils.Bernstein
    i = undefined
    i = 0
    while i <= n
      b += pw(1 - k, n - i) * pw(k, i) * v[i] * bn(n, i)
      i++
    b

  CatmullRom: (v, k) ->
    m = v.length - 1
    f = m * k
    i = Math.floor(f)
    fn = utils.CatmullRom
    if v[0] is v[m]
      i = Math.floor(f = m * (1 + k))  if k < 0
      fn v[(i - 1 + m) % m], v[i], v[(i + 1) % m], v[(i + 2) % m], f - i
    else
      return v[0] - (fn(v[0], v[0], v[1], v[1], -f) - v[0])  if k < 0
      return v[m] - (fn(v[m], v[m], v[m - 1], v[m - 1], f - m) - v[m])  if k > 1
      fn v[(if i then i - 1 else 0)], v[i], v[(if m < i + 1 then m else i + 1)], v[(if m < i + 2 then m else i + 2)], f - i
