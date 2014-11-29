---
layout: post
title: Lexical Scoping - Newton's square root algorithm
lang: scheme
tags: scheme
---

### Newton's square root algorithm side-by-side

<div class="compare">
{% highlight scheme %}

; no lexical scoping

(define (in-tolerance? x g t) (< (abs (- x (* g g))) t))

(define (guess x g) (/ (+ (/ x g) g) 2))

(define (square-root-core x g t) 
  (if
   (in-tolerance? x g t)
   g
   (square-root-core x (guess x g) t)))

(define (square-root x)
  (square-root-core x 1 (/ x 1000000)))

(square-root 0.0000002)
(sqrt 0.0000002)

{% endhighlight %}
</div>

<div class="compare">
{% highlight scheme %}

; lexical scoping

(define (square-root x)
  (define (in-tolerance? g t) (< (abs (- x (* g g))) t))

  (define (guess g) (/ (+ (/ x g) g) 2))

  (define (square-root-core g t) 
    (if
      (in-tolerance? g t)
      g
      (square-root-core (guess g) t)))
  (square-root-core 1 (/ x 1000000)))

(square-root 0.0000002)
(sqrt 0.0000002)

{% endhighlight %}
</div>
