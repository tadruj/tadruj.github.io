---
layout: post
title: Recursive process
lang: scheme
tags: scheme
---

### Recursive process implemented as recursive and iterative procedures

While a process might be recursive (WHAT), it may be implemented (HOW) as a recursive procedure or iterative procedure.

### Exponentiation example side-by-side

<div class="compare">
{% highlight scheme %}

; recursive process and recursive procedure
(define (exponentiate b n)
  (if (= n 0)
  1
  (* b (exponentiate b (- n 1))))) ; dirty

(exponentiate 2 1)
(exponentiate 2 2)
(exponentiate 2 3)
(exponentiate 2 4)

{% endhighlight %}
</div>

<div class="compare">
{% highlight scheme %}

; recursive process and iterative procedure
(define (exponentiate-iter b n acc)
  (if (= n 0)
  acc
  (exponentiate-iter b (- n 1) (* b acc)))) ; pure

(exponentiate-iter 2 1 1)
(exponentiate-iter 2 2 1)
(exponentiate-iter 2 3 1)
(exponentiate-iter 2 4 1)

{% endhighlight %}
</div>

**Recursive procedure**

calls itself in a dirty way, so the interpreter has to put some extra information about the call to the stack every iteration and then re-execute backwards.

    input ->
      proc, push ->
        proc, push ->
          proc, push ->
          pop, proc ->
        pop, proc ->
      pop, proc ->
    output

**Iterative procedure**

calls itself in a pure way, the call containing all the information for the next procedure execution.

Visually this can be represented as a chain of procedures, which at the end return a result. This is practically a for loop implemented with recursion. A strategy with accumulators is a common way of implementing simpler processes.

    input -> 
    proc -> 
    proc -> 
    proc -> 
    output
