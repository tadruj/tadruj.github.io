;; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;; An Introduction to ClojureScript for Light Table users
;; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


;; Basics
;; ============================================================================

;; To begin, open the command pane (type Control-SPACE), Add Connection, select
;; Light Table UI. Once connected you can evaluate all the forms in this file
;; by placing the cursor after the form and typing Command-ENTER.

;; IMPORTANT: You must evaluate the very first form, the namespace
;; definition.

;; Declaring a namespaces
;; ----------------------------------------------------------------------------

;; ClojureScript supports modularity via namespaces. They allow you to group
;; logical definitions together.

(ns lt-cljs-tutorial
  (:require [clojure.string :as string]))

;; :require is how you can import functionality from a different namespace into
;; the current one. Here we are requiring `clojure.string` and giving it an
;; alias. We could write the following:

;; =============================================================
;;
;; IMPORTANT !!!
;;
;; Remember you can type Control-Shift-D at anytime to bring up
;; the documentation panel to see what any of these function do.
;;
;; =============================================================

(clojure.string/blank? "")

;; But that's really verbose compared to:

(string/blank? "")


;; Comments
;; ----------------------------------------------------------------------------

;; There are three ways to create comments in ClojureScript. The first way is
;; by preceding a line with a semi-colon, just like the lines you are reading
;; now.

;; The second way is by preceding a form with `#_`. This causes ClojureScript
;; to skip the evaluation of only the form immediately following, without
;; affecting the evaluation of the surrounding forms.

;; Try to reveal the secret message below:

(str "The secret word is " #_(string/reverse "tpircSerujolC"))

;; Finally, you can also create a comment using the `comment` macro. One common
;; technique is to use the `comment` macro to include code to be evaluated in a
;; REPL, but which you do not normally want to be included in the compiled
;; source.

;; For example, try placing your cursor after the last `)` below and type
;; Command-ENTER:

(comment

  (string/upper-case "This is only a test...")

  )

;; The `comment` macro makes the whole form return `nil`. Now go back and
;; highlight just the middle line, then type Command-ENTER. In this way
;; you can include code samples or quick tests in-line with the rest of
;; your code.


;; Definitions
;; ----------------------------------------------------------------------------

;; Once you have a namespace, you can start creating top level definitions in
;; that namespace.

;; You can define a top level with `def`.

(def x 1)

x

;; You can also refer to top level definitions by fully qualifying them.

lt-cljs-tutorial/x

;; This means top levels can never be shadowed by locals and function
;; parameters.

(let [x 3])
(let [x 3] x)
(let [x 3 x' x] x')
x
x'

(let [x 2]
  lt-cljs-tutorial/x)
;; One way to define a function is like this.

(def fruit-map
  {:apple "jabolko"
   :tomato "paradajz"
   :pear "gruska"})

(defn en-to-sl [english-word]
  (let [slovenian-word (get fruit-map english-word)
        slovenian-backward-word (reverse slovenian-word)]
    (clojure.string/join slovenian-backward-word)))
(en-to-sl :apple)

(def y (fn [] 1))

(y)

(def sum' (fn [a' b'] (+ a' b')))
(sum' 3 4)

(def mul' (fn [a' b'] (* a' b')))
(mul' 3 4)

;; Defining functions in ClojureScript is common enough that `defn` sugar is
;; provided and idiomatic.

(defn z [] 1)

(z)

(defn sum'' [a' b'] (+ a' b'))
(sum'' 5 6)

(defn mul'' [a'' b''] (* a'' b''))
(mul'' 5 6)

;; Literal data types
;; ----------------------------------------------------------------------------

;; ClojureScript comes out of the box with the usual useful data literals.

;; Booleans

(def a-boolean true)

;; Strings

(def a-string "Hello!")

;; Regular Expressions

(def a-regexp #"\d{3}-?\d{3}-?\d{4}")

;; Numbers

(def a-number 1)


;; Function literals
;; ----------------------------------------------------------------------------

;; ClojureScript also supports a shorthand function literal which is useful
;; You can use the % and %N placeholders to represent function arguments.

;; You should not abuse the function literal notation as it degrades readability
;; outside of simple cases. It is nice for simple functional cases such as
;; the following. You could map over a ClojureScript vector like this:

(map (fn [n] (* n 2)) [1 2 3 4 5])

;; Or you can save typing a few characters like this:

(map #(* % 2) [1 2 3 4 5])
(map #(* % 3) [1 2 3])

(#(+ % 2) 3)
(#(+ %1 %2) 3 4)

;; JavaScript data type literals
;; ----------------------------------------------------------------------------

;; You can construct a JavaScript array with the `array` function.

(def an-array (array 1 2 3))

(map #(* % 2) (array 3 4 5))

;; But ClojureScript also supports JavaScript data literals via the `#js`
;; reader literal.

(def another-array #js [1 2 3])

(map #(* % 2) #js [1 2 3])

;; Similarly, you can create simple JavaScript objects with `js-obj`.

(def an-object (js-obj "foo" "bar"))

;; But again you can save a few characters with `#js`.

(def another-object #js {"foo" "bar"})

(def another-object' #js {:foo "bar"})

;; It's important to note that `#js` is shallow, the contents of `#js` will be
;; ClojureScript data unless preceded by `#js`.

;; This is a mutable JavaScript object with an immutable ClojureScript vector
;; inside.

(def shallow #js {"foo" [1 2 3]})

;; convert native clj data type to js one
(clj->js {:foo [1 2 3]})

(def shallow' #js {:foo #js [1 2 3]})

;; Constructing a type
;; ----------------------------------------------------------------------------

;; Of course some JavaScript data types you will want to create with a
;; constructor.

;; (js/Date.) is equivalent to new Date().

(def a-date (js/Date.))

(def another-date #inst "2014-01-15")

;; #inst is a reader macro, anything with a # is a reader macro that pattern matches
;; the thing you give it and returns something useful

;; #() is the reader macro to expand into (fn [%..] ...)
;; #inst, #"" is regexp

(def another-date #inst "2014-01-16")

;; Note the above returns an `#inst` data literal.

(def another-regexp (js/RegExp. "\\d{3}-?\\d{3}-?\\d{4}"))

;; Handy

;; NOTE: js/Foo is how you refer to global JavaScript entities of any kind.

js/Date

js/RegExp

js/requestAnimationFrame

(js/console.log "This should be visible in console. Cool.")

;; If you're curious about other JavaScript interop jump to the bottom of this
;; tutorial.


;; ClojureScript data types
;; ============================================================================

;; Unless there is a good reason, you should generally write your ClojureScript
;; programs with ClojureScript data types. They have many advantages over
;; JavaScript data types - they present a uniform API and they are immutable.

;; Vectors
;; ----------------------------------------------------------------------------

;; Instead of arrays, ClojureScript programmers use persistent vectors. They are
;; like arrays - they support efficient random access, efficient update
;; and efficient addition to the end.

(def a-vector [1 2 3 4 5])

;; We can get the length of a vector in constant time via `count`.

(count a-vector)

;; We can add an element to the end.

(def another-vector (conj a-vector 6))
(def another-vector' (conj a-vector 6 7 8))
(conj a-vector 6 7 8)

;; Note this does not mutate the array! `a-vector` will be left
;; unchanged.

a-vector

another-vector
another-vector'

;; Hallelujah! Here is where some ClojureScript magic
;; happens. `another-vector` appears to be a completely new vector
;; compared to `a-vector`. But it is not really so. Internally, the new
;; vector efficiently shares the `a-vector` structure. In this way, you
;; get the benefits of immutability without paying in performance.

;; We can access any element in a vector with `nth`. The following
;; will return the second element.

(nth a-vector 1)

(nth ["foo" "bar" "baz"] 1)

;; Or with `get`...

(get a-vector 0)

;; ...which allows you to return an alternate value when the index is
;; out-of bounds.

(get a-vector -1 :out-of-bounds)
(get a-vector (count a-vector) :out-of-bounds)

;; Surprisingly, vectors can be treated as functions. This is actually
;; a very useful property for associative data structures to have as
;; we'll see below with sets.

a-vector
(a-vector 1)
(["foo" "bar" "baz"] 1)


;; Maps
;; ----------------------------------------------------------------------------

;; Along with vectors, maps are the most common data type in ClojureScript.
;; Map usage is analogous to the usage of Object in JavaScript, but
;; ClojureScript maps are immutable and considerably more flexible.

;; Let's define a simple map. Note `:foo` is a ClojureScript keyword.
;; ClojureScript programmers prefer to use keywords for keys instead
;; of strings. They are more distinguishable from the rest of the
;; code, more efficient than plain strings, and they can be used in
;; function position (i.e. first position after the open parens), as
;; we'll see in a moment.

(def a-map {:foo "bar" :baz "woz"})
{:rok "Krulex", :ana "Krulex"}

;; We can get the number of key-value pairs in constant time.

(count a-map)

;; We can access a particular value for a key with `get`.

(get a-map :foo)
({:foo "bar" :baz "woz"} :baz)
({:foo "bar" :baz "woz"} :bag :default-if-no-bag)

;; and return an alternative value when the key is not present

(get a-map :bar :not-found)

;; We can add a new key-value pair with `assoc`.

(def another-map (assoc a-map :noz "goz"))

;; Again a-map is unchanged! Same magic as before for vectors

a-map

another-map

;; We can remove a key-value pair with `dissoc`.

(dissoc a-map :foo)

;; Again a-map is unchanged!

a-map

;; Like vectors, maps can act like functions.

(a-map :foo)

;; However ClojureScript keywords themselves can act like functions and the
;; following is more idiomatic.

(:foo a-map)

;; We can check if a map contains a key, with `contains?`.

(contains? a-map :foo)

;; We can get all the keys in a map with `keys`.

(keys a-map)

;; And all of the values with `vals`.

(vals a-map)

;; We can put a lot of things in a map, even other maps
(def a-nested-map {:customer-id 1e6
                   :preferences {:nickname "Bob"
                                 :avatar "http://en.gravatar.com/userimage/0/0.jpg"}
                   :services {:alerts {:daily true}}})

;; and navigate its keys to get the nested value you're interested in

(get-in a-nested-map [:preferences :nickname])
(get-in a-nested-map [:services :alerts :daily])

({:name "Rok" :birth {:day 31}} :birth :day)
(:name {:name "Rok" :birth {:day 31}})
(:birth {:name "Rok" :birth {:day 31}})

;; or just find a top level key-value pair (i.e. MapEntry) by key

(find a-nested-map :customer-id)
(find a-nested-map :services)

(find {:name "Rok" :birth {:day 31}} :birth)

;; There are many cool ways to create maps.

(zipmap [:foo :bar :baz] [1 2 3])

(hash-map :foo 1 :bar 2 :baz 3)
(hash-map :foo 1 :bar 2)


(apply hash-map [:foo 1 :bar 2 :baz 3])
{:foo 1 :bar 2 :baz 3}

(into {} [[:foo 1] [:bar 2] [:baz 3]])

;; Unlike JavaScript objects, ClojureScript maps support complex keys.

(def complex-map {[1 2] :one-two [3 4] :three-four})
(get complex-map [3 4])

;; This is BADASS
{[1 2] "arraykey this is value" {:k1 :v1 :k2 v2} "mapkey this is value"}

;; Keyword digression
;; ----------------------------------------------------------------------------

;; Let's take a moment to digress about keywords as they are so ubiquitous
;; in ClojureScript code.

(identity :foo)

;; If you add an additional preceding colon you'll get a namespaced keyword.

(identity ::foo)

;; What good is this for? It allows you to put data into collections without
;; fear of namespace clashes without the tedium of manual namespacing them
;; in your source.

(identity {:user/foo ::foo})

;; Namespaced keywords are essential to Light Table's modularity.


;; Sets
;; ----------------------------------------------------------------------------

;; ClojureScript also supports sets.

(def a-set #{:cat :dog :bird})
(conj #{:cat :dog :bird} :fish)
(conj #{:cat :dog :bird} :fish :cat)
(conj #{:cat :dog :bird} :fish :cat 33 "foo")

;; `:cat` is already in `a-set`, so it will be unchanged.

(conj a-set :cat)

;; But `:zebra` isn't.

(conj a-set :zebra)

;; If you haven't guessed already, `conj` is a "polymorphic" function that adds
;; an item to a collection. This is some of the uniformity we alluded to
;; earlier.

;; `contains?` works on sets just like it does on maps.

(contains? a-set :cat)

;; Like vectors and maps, sets can also act as functions. If the argument
;; exists in the set it will be returned, otherwise the set will return nil.

(#{:cat :dog :bird} :cat)

;; This is powerful when combined with conditionals.

(defn check [x]
  (if (#{:cat :dog :bird} x)
    :valid
    :invalid))

(check :cat)
(check :zebra)


;; Lists
;; ----------------------------------------------------------------------------

;; A less common ClojureScript data structure is lists. This may be
;; surprising as ClojureScript is a Lisp, but maps, vectors and sets
;; are the 'go-to' data structures for most applications. Still, lists are sometimes
;; useful—especially when dealing with code (i.e. code is data).

(def a-list '(:foo :bar :baz))
'(:foo :bar :baz)

;; `conj` is "polymorphic" on lists as well, and it's smart enough to
;; add the new item in the most efficient way on the basis of the
;; collection type.
(conj a-list :front)
(conj '() :first)

;; and lists are immutable as well

a-list

;; You can get the first element of a list

(first a-list)

;; or the tail of a list

(rest a-list)

;; which allows you to easly verify how ClojureScript shares data
;; structure instead of inefficiently copying data for supporting
;; immutability.

(def another-list (conj a-list :front))

another-list

a-list

(identical? (rest another-list) a-list)

;; `identical?` checks whether two things are represented by the same
;; thing in memory.


;; Equality
;; ============================================================================

;; ClojureScript has a much simpler notion of equality than what is present
;; in JavaScript. In ClojureScript equality is always deep equality.

(= {:one 1 :two "2"} {:one 1 :two "2"})

;; Maps are not ordered.

(= {:one 1 :two "2"} {:two "2" :one 1})

;; For sequential collections, equality just works.

(= [1 2 3] '(1 2 3))

;; Lists should be used in any code generation = macros, vectors should be used where there's appending/prepending

;; Again, it is possible to check whether two things are represented
;; by the same thing in memory with `identical?`.

(def my-vec [1 2 3])
(def your-vec [1 2 3])

(identical? my-vec your-vec)


;; Control
;; ============================================================================

;; In order to write useful programs, we need to be able to express
;; control flow. ClojureScript provides the usual control constructs,
;; however truth-y and false-y values are not the same as in
;; JavaScript so it's worth reviewing.

;; if
;; ----------------------------------------------------------------------------

;; 0 is not a false-y value.

(if 0
  "Zero is not false-y"
  "Yuck")

;; Nor is the empty string.

(if ""
  "An empty string is not false-y"
  "Yuck")

;; the empty vector

(if []
  "An empty vector is not false-y"
  "Yuck")

;; the empty list

(if ()
  "An empty list is not false-y"
  "Yuck")

;; the empty map

(if {}
  "An empty map is not false-y"
  "Yuck")

;; the empty set

(if #{}
  "An empty set is not false-y"
  "Yuck")

;; and even the empty regexp

(if #""
  "An empty regexp is not false-y"
  "Yuck")

;; The only false-y values in ClojureScript are `nil` and `false`. `undefined`
;; is not really a valid ClojureScript value and is generally coerced to `nil`.


;; cond
;; ----------------------------------------------------------------------------

;; Nesting `if` tends to be noisy and hard to read so ClojureScript
;; provides a `cond` macro to deal with this.

(cond
  nil "Not going to return this"
  false "Nope not going to return this either"
  :else "Default case")


;; loop/recur
;; ----------------------------------------------------------------------------

;; The most primitive looping construct in ClojureScript is `loop`/`recur`.
;; Like `let`, `loop` establishes bindings and allows you to set their initial values.
;; Like `let`, you may have a sequence of forms for the body. In tail
;; positions, you may write a `recur` statement that will set the bindings for
;; the next iteration of the `loop`. Using `loop`/`recur` is usually considered bad
;; style if a reasonable functional solution via `map`/`filter`/`reduce` or a list
;; comprehension is possible.

;; While you might write this in JavaScript:
;;
;; var ret = [];
;; for(var i = 0; i < 10; i++) ret.push(i)
;;
;; In ClojureScript you would write `loop`/`recur` like so:

(loop [i 0 ret []]
  (if (< i 10)
    (recur (inc i) (conj ret i))
    ret))

;; Again avoid `loop`/`recur` unless you really need it. The loop above would
;; be better expressed as the following:

(into [] (range 10))
(range 10)

'(1 2 3)
(into [] '(1 2 3))

;; Moar functions
;; ============================================================================

;; Functions are the essence of any significant ClojureScript program, so
;; we will dive into features that are unique to ClojureScript functions that
;; might be unfamiliar.

;; Here is a simple function that takes two arguments and adds them.

(defn foo1 [a b]
  (+ a b))

(#(+ %1 %2) 1 2)

(foo1 1 2)

(defn sum'' [a b] (+ a b))
(sum'' 1 2)

;; Functions can have multiple arities.

(defn foo2
  ([a b] (+ a b))
  ([a b c] (* a b c)))

(foo2 3 4)
(foo2 3 4 5)

;; Multiple arities can be used to supply default values.

(defn defaults
  ([x] (defaults x :default))
  ([x y] [x y]))

(defaults :explicit)
(defaults :explicit1 :explicit2)

;; Functions support rest arguments.

(defn foo3 [a b & d]
  [a b d])

(foo3 1 2)
(foo3 1 2 3 4)

;; You can apply functions.

(apply + [1 2 3 4 5])


;; multimethods
;; ----------------------------------------------------------------------------

;; Often when you need some polymorphism, and performance isn't an issue,
;; multimethods will suffice. Multimethods are functions that allow open
;; extension, but instead of limiting dispatch to type, dispatch is controlled
;; by whatever value the dispatch fn originally supplied to `defmulti` returns.

;; Here is the simplest multimethod you can write. It simply dispatches on
;; the value received.

(defmulti simple-multi identity)
identity
(identity)
(identity 1)
(identity :foo)
(identity :foo :bar)

;; Now we can define methods for particular values.

(defmethod simple-multi 1
  [value] "Dispatched on 1")

(simple-multi 1)

(defmethod simple-multi "foo"
  [value] "Dispatched on foo")

(simple-multi "foo")

;; However we haven't defined a case for "bar"
; (Highlight and evaluate the `simple-multi` form below)
(comment
  (simple-multi "bar")
  )

;; Here is a function that takes a list. It dispatches on the first element
;; of the list!
;; Note that this example uses destructuring, which is covered later.

(defmulti parse (fn [[f & r :as form]] f))

(defmethod parse 'if
  [form] {:op :if})

(defmethod parse 'let
  [form] {:op :let})

(parse '(if a b c))
(parse '(let [x 1] x))


;; A function that's going to return the value to be pattern matched
(defmulti do' (fn [first last] [first last]))

;; pattern matching on values
(defmethod do' ["Rok" "Krulex"]
  [first last] {:first first :last last})

;; pattern matching on values
(defmethod do' ["Ana" "Krulex"]
  [first last] {:first (str first "banana") :last last})

(do' "Rok" "Krulex")

(do' "Ana" "Krulex")

(def lang-sl {:apple "jabolko" :tomato "paradajz" :eat "pojem" :peel "olupim" :nevem "nevem"})

;; Check the first argument of the function and dispatch an appropriate handler
(defmulti perform (fn [object] [object]))

;; handler destructures the arguments any way it likes
(defmethod perform [:apple]
  [object verb]
  (str (verb lang-sl) " " (object lang-sl)))

(defmethod perform :default
  [object verb]
  (str (lang-sl :nevem) " " (:nevem lang-sl)))

(perform :apple :eat)
(perform :apple :peel)
(perform :tomato :eat)
;; https://www.refheap.com/96811

;; Scoping
;; ============================================================================

;; Unlike JavaScript, there is no hoisting in ClojureScript. ClojureScript
;; has lexical scoping.

(def some-x 1)

(let [some-x 2]
  some-x)

some-x

;; Closures
;; ----------------------------------------------------------------------------

;; Could a language with such a name miss closures? Surely it can't. You
;; may be already familiar with them in JavaScript, even if it's a
;; variable scoped language.

(let [a 1e3]
  (defn foo []
    (* a a))
  (defn bar []
    (+ (foo) a)))

;; Above we defined `foo` and `bar` functions inside the scope of a
;; `let` form and they both know about `a` (i.e. they close over `a`)
;; Note, even if defined inside a `let`, `foo` and `bar` are available
;; in the outer scope. This is because all `def` expressions are always
;; top level. See the footnote at the end of this section.


(foo)
(bar)

;; And Nobody else.
(comment
  (defn baz []
    (type a))
  (baz)
  )

;; That's why some people say that closures are the poor man's objects.
;; They encapsulate the information as well.

;; But in ClojureScript, functions' parameters and let bindings' locals
;; are not mutable! That goes for loop locals, too!

(let [fns (loop [i 0 ret []]
            (if (< i 10)
              (recur (inc i) (conj ret (fn [] i)))
              ret))]
  (map #(%) fns))

;; In JavaScript you would see a list of ten 9s. In ClojureScript we
;; see the expected numbers from 0 to 9.

;; FOOTNOTE:
;;
;; `def` expressions (including `defn`) are always top level. People familiar
;; with Scheme or other Lisps often mistakenly write the following in Clojure:

(defn not-scheme []
  (defn no-no-no []))

;; This is almost always incorrect. If you need to write a local function just
;; do it with a let binding.

(defn outer-fn []
  (let [inner-fn (fn [])]))


;; Destructuring
;; ============================================================================

;; In any serious ClojureScript program, there will be significant amounts of
;; data manipulation. Again, we will see that ClojureScript's uniformity
;; pays off.

;; In ClojureScript anywhere bindings are allowed (like `let` or function
;; parameters), destructuring is allowed. This is similar to the destructuring
;; proposed for ES6, but the system provided in ClojureScript benefits from
;; all the collections supporting uniform access.


;; Sequence destructuring
;; ----------------------------------------------------------------------------

;; Destructuring sequential types is particularly useful.

(let [[f & r] '(1 2 3)]
  f)

(let [[f & r] '(1 2 3)]
  r)

(let [[r g b] [255 255 150]]
  g)

(let [[r g b] [255 255 150]]
  [g r b])

;; _ is just a convention for saying that you are not interested at the
;; item in the corresponding position. it has no other special meaning.
;; Here we're only interested at the third local variable named `b`.

(let [[_ _ b] [255 255 150]]
  b)

;; destructuring function arguments works just as well. Here we are
;; only intersted at the second argument `g`.

(defn green [[_ g _]] g)

(green [255 255 150])


;; Map destructuring
;; ----------------------------------------------------------------------------

;; Map destructuring is also useful. Here we destructure the value for the
;; `:foo` key and bind it to a local `f`, and the value for `:baz` key
;; and bind it to a local `b`.

(let [{f :foo b :baz} {:foo "bar" :baz "woz"}]
  [f b])

;; If we don't want to rename, we can just use `:keys`.

(let [{:keys [first last]} {:first "Bob" :last "Smith"}]
  [first last])

; We can also destructure a nested map

(let [{:keys [first last] {:keys [addr1 addr2]} :address} {:first "Bob" :last "Smith" :address {:addr1 "123" :addr2 "Main street"}}]
  [first last addr1 addr2])

; Similar to :keys for keyword, :strs and :syms directives are available for matching string and symbol :keys

(let [{:strs [first last]} {"first" "Bob" "last" "Smith"}]
  [first last])

(let [{:syms [first last]} {'first "Bob" 'last "Smith"}]
  [first last])

;; The above map destructuring form is very useful when you need to
;; define a function with optional, non positional and defaulted
;; arguments.

(defn magic [& {:keys [k g h]
                :or {k 1
                     g 2
                     h 3}}]
  (hash-map :k k
            :g g
            :h h))

(magic)
(magic :k 10)
(magic :g 100)
(magic :h 1000)
(magic :k 10 :g 100 :h 1000)
(magic :h 1000 :k 10 :g 100)

;; Sequences
;; ============================================================================

;; We said that ClojureScript data structures are to be preferred as they
;; provide a uniform interface. All ClojureScript collections satisfy
;; the ISeqable protocol, which means iteration is uniform
;; (i.e. polymorphic) for all collection types.


;; Map / Filter / Reduce
;; ----------------------------------------------------------------------------

;; ClojureScript supports the same bells and whistles out of the box that you may
;; be familiar with from other functional programming languages or JavaScript
;; libraries such as Underscore.js

(map inc [0 1 2 3 4 5 6 7 8 9])

(filter even? (range 10))

(remove odd? (range 10))

;; ClojureScript's `map` and `filter` operations are lazy. You can stack up
;; operations without getting too concerned about multiple traversals.

(map #(* % %) (filter even? (range 20)))

(reduce + (range 100))


;; List comprehensions
;; ----------------------------------------------------------------------------

;; ClojureScript supports the list comprehensions you might know from various
;; languages. List comprehensions are sometimes more natural or more readable
;; than a chain of `map` and `filter` operations.

(for [x (range 1 10)
      y (range 1 10)]
  [x y])

(range 1 10)
(range 10)
(range 5 10)

(for [x '(1 2 3)
      y '(4 5 6)
      z '(7 8 9)
      w '(:a :b :c)]
  [x y z w])

(for [x '(1 2 3)
      y '(4 5 6)
      z '(7 8 9)
      :let [w (* x 2)]
      :when (= (mod w 4) 0)]
  [x y z w])

(for [x (range 1 10)
      y (range 1 10)
      :when (and (zero? (rem x y))
                 (even? (quot x y)))]
  [x y])

(for [x (range 1 10)
      y (range 1 10)
      :let [prod (* x y)]]
  [x y prod])


;; Seqable collections
;; ----------------------------------------------------------------------------

;; Most ClojureScript collections can be coerced into sequences.

(seq {:foo "bar" :baz "woz"})
(seq #{:cat :dog :bird})
(seq [1 2 3 4 5])
(seq '(1 2 3 4 5))

;; Many ClojureScript functions will call `seq` on their arguments in order to
;; provide the expected behavior. The following demonstrates that you can
;; uniformly iterate over all the ClojureScript collections!

(first {:foo "bar" :baz "woz"})
(rest {:foo "bar" :baz "woz"})

(first #{:cat :dog :bird})
(rest #{:cat :dog :bird})

(first [1 2 3 4 5])
(rest [1 2 3 4 5])

(first '(1 2 3 4 5))
(rest '(1 2 3 4 5))


;; Metadata
;; ============================================================================

;; All of the ClojureScript standard collections support metadata. Metadata
;; is a useful way to annotate data without affecting equality. The
;; ClojureScript compiler uses this language feature to great effect.

;; You can add metadata to a ClojureScript collection with `with-meta`. The
;; metadata must be a map.

(def plain-data [0 1 2 3 4 5 6 7 8 9])

(def decorated-data (with-meta plain-data {:url "http://lighttable.com"}))

(meta (with-meta '(1 2 3) "Just a list"))

;; Metadata has no effect on equality.

(= plain-data decorated-data)

;; You can access metadata with `meta`.

(meta decorated-data)


;; Error Handling
;; ============================================================================

;; Error handling in ClojureScript is relatively straightforward and more or
;; less similar to what is offered in JavaScript.

;; You can construct an error like this.

(js/Error. "Oops")

;; You can throw an error like this.
;; (Highlight and evaluate the `throw` form below)

(comment
  (throw (js/Error. "Oops"))
  )

;; You can catch an error like this.

(try
  (throw (js/Error. "Oops"))
  (catch js/Error e
    e))

;; JavaScript unfortunately allows you to throw anything. You can handle
;; this in ClojureScript with the following.

(try
  (throw (js/Error. "Oops"))
  (catch :default e
    e))

;; Catches are optional. You can also use multiple forms to handle different types of errors.

(try
  (throw (js/Error. "Oops"))
  (catch js/Error e
    e)
  (catch Error e
    e)
  (finally
     "Cleanup here"))


;; Mutation
;; ============================================================================

;; Atoms
;; ----------------------------------------------------------------------------

;; A little bit of mutability goes a long way. ClojureScript does not offer
;; any traditional mutable data structures, however it does support identities
;; that can evolve over time via `atom`.

(def x (atom 1))

;; You can dereference the value of an atom with `@`.

@x

;; This is equivalent to calling `deref`.

(deref x)

;; You can redefine the value

(def x (atom 3))

x

@x

;; or

;; If you want to change the value of an atom you can use `reset!` which returns
;; the new value. It's idiomatic to add the bang char `!` at the end of function
;; names mutating objects.

(reset! x 2)

x

@x

;; swap!
;; ------------------------------------------------------------------------------

;; If you want to change the value of an atom on the basis of its current value,
;; you can use `swap!`. In its simplest form, `swap!` accepts as a first argument
;; the atom itself and as a second argument an updating function of one argument
;; which will be instantiated with the current value of the atom. `swap!` returns
;; the new value of the atom.

(swap! x inc)

x

@x

(swap! x #(* % 2))

x

@x

(swap! x (fn [x] (quot x 5)))

x

@x

;; If your updating function needs extra arguments to calculate the new value, you
;; have to pass them as extra arguments to `swap!` after the updating function
;; itself.

(swap! x (fn [old extra-arg]
           (+ old extra-arg)) 39)

x

@x

(swap! x #(* %1 %2) 2)

x

@x

(swap! x #(%2 %1 2) quot)

x

@x

(swap! x #(%2 %1 2) +)

x

@x

;; As usual when anonymous functions are simple enough, it's idiomatic to use
;; the condensed form.

(swap! x #(- %1 %2) 42)

x

@x

;; Note that the updating function has to be free of side-effects because a
;; waiting writer could call it more than once in a spin loop.


;; set!
;; ----------------------------------------------------------------------------

;; Sometimes you need to mutate existing JavaScript objects. For this you
;; have `set!`.

(def c (.createElement js/document "canvas"))
(def ctxt (.getContext c "2d"))

;; We can use property access with `set!` to change the fill color of a
;; a canvas rendering context.

(set! (.-fillColor ctxt) "#ffffff")


;; The ClojureScript Standard Library
;; ============================================================================

;; The ClojureScript standard library largely mirrors the Clojure standard
;; library with the exception of functionality that assumes a multithreaded
;; environment, first class namespaces, and Java numerics.

;; Here are some highlights and patterns that newcomers to ClojureScript might
;; find useful. Remember you can type Control-Shift-D at anytime to bring up
;; the documentation panel to see what any of these function do.

(apply str (interpose ", " ["Bob" "Mary" "George"]))

;; juxt take n functions and applies them to all arguments returning a vector item for each function
((juxt :first :last) {:first "Bob" :last "Smith"})

(def people [{:first "John" :last "McCarthy"}
             {:first "Alan" :last "Kay"}
             {:first "Joseph" :last "Licklider"}
             {:first "Robin" :last "Milner"}])

(map :first people)

(take 5 (repeat "red"))

(take 5 (repeat "blue"))

(take 5 (interleave (repeat "red") (repeat "blue")))

(take 10 (cycle ["red" "white" "blue"]))

(partition 2 [:a 1 :b 2 :c 3 :d 4 :e 5])
;; create lists/tuples of SIZE:%1 and STEP:%2
(partition 2 1 [:a 1 :b 2 :c 3 :d 4 :e 5])
(partition 3 [:a 1 :b 2 :c 3 :d 4 :e 5])
(partition 3 2 [:a 1 :b 2 :c 3 :d 4 :e 5])
(partition 3 1 [:a 1 :b 2 :c 3 :d 4 :e 5])

(take-while #(< % 5) (range 10))

(drop-while #(< % 5) (range 10))


;; Protocols
;; ============================================================================

;; The ClojureScript language is constructed on a rich set of protocols. The
;; same uniformity provided by ClojureScript collections can be extended to
;; your own types or even types that you do not control!

;; A lot of the uniform power we saw early was because the ClojureScript
;; collections are implemented in terms of protocols. Collections can be
;; coerced into sequences because they implement ISeqable. You can use `get`
;; on vectors and maps because they implement ILookup.

(get {:foo "bar"} :foo)
(get [:cat :bird :dog] 1)

;; Map destructuring actually desugars into `get` calls. That means if you extend
;; your type to ILookup it will also support map destructuring!


;; extend-type
;; ----------------------------------------------------------------------------

;; ClojureScript supports custom extension to types that avoid many of the
;; pitfalls that you encounter in other languages. For example imagine we have
;; some awesome polymorphic functionality in mind.

(defprotocol MyProtocol (awesome [this]))

;; It's idiomatic to name the first argument of a protocol's functions
;; as `this` which reminds you that it is the argument used by
;; ClojureScript to dispatch the right function implementation on the
;; basis of the type of the value of `this`

;; Now imagine we want JavaScript strings to participate. We can do this
;; simply.

(extend-type string
  MyProtocol
  (awesome [this] (vector this "Totally awesome!")))

(awesome "Is this awesome?")


;; extend-protocol
;; ----------------------------------------------------------------------------

;; Sometimes you want to extend several types to a protocol at once. You can
;; use extend-protocol for this. extend-protocol simply desugars into multiple
;; extend-type forms.

;; As said while learning about `let` special form, when we're not
;; interested in the value of an argument it's idiomatic to use the
;; underscore as a placeholder like above.

(extend-protocol MyProtocol
  js/Date
  (awesome [_] "Having an awesome time!")
  number
  (awesome [_] "I'm an awesome number!"))

(awesome #inst "2014")
(awesome 5)


;; reify
;; ----------------------------------------------------------------------------

;; Sometimes it's useful to make an anonymous type which implements various
;; protocols.

;; For example say we want a JavaScript object to support ILookup. Now we don't
;; want to blindly `extend-type object`, that would pollute the behavior of plain
;; JavaScript objects for everyone.

;; Instead we can provide a helper function that takes an object and returns
;; something that provides this functionality.

(defn ->lookup [obj]
  (reify
    ILookup
    (-lookup [this k]
      (-lookup this k nil))
    (-lookup [this k not-found]
      (let [k (name k)]
        (if (.hasOwnProperty obj k)
          (aget obj k)
          not-found)))))

(name :foo)
(aget #js {:foo "bar"} "foo")

;; We can then selectively make JavaScript objects work with `get`.

(get (->lookup #js {"foo" "bar"}) :foo)
(get (->lookup #js {"foo" "bar"}) :fox)

;; But this also means we get destructuring on JavaScript objects.

(def some-object #js {"foo" "bar" "baz" "woz"})

(let [{:keys [foo baz]} (->lookup some-object)]
  [foo baz])


;; specify
;; ----------------------------------------------------------------------------

;; Light Table ships with a older version of ClojureScript and does not yet
;; support specify


;; Macros
;; ============================================================================


;; Types & Records
;; ============================================================================

;; deftype
;; ----------------------------------------------------------------------------

;; Sometimes a map will simply not suffice, in these cases you will want to
;; make your own custom type.

(deftype Foo [a b])

;; It's idiomatic to use CamelCase to name a `deftype`. You can instantiate a
;; deftype instance using the same constructor pattern we've already discussed.

(Foo. 1 2)

;; You can access properties of a deftype instance using property access
;; syntax.

(.-a (Foo. 1 2))

;; You can implement protocol methods on a deftype. Note that the first
;; argument to any deftype or defrecord method is the instance itself.
;; The dash in `-count` has no special meaning. It's just a convention for
;; the core ClojureScript protocols. You need not adopt it.

(deftype Foo [a b]
  ICounted
  (-count [this] 2))

(count (Foo. 1 2))

;; Sometimes it's useful to implement methods directly on the deftype.

(deftype Foo [a b]
  Object
  (toString [this] (str a ", " b)))

(.toString (Foo. 1 2))

;; deftype fields are immutable unless specified. The following will not compile.
;; (To prove it to yourself, highlight and evaluate the `deftype` form below.)

(comment

  (deftype Foo [a ^:mutable b]
    Object
    (setA [this val] (set! a val)))

  )

;; The following will compile.

(deftype Foo [a ^:mutable b]
  Object
  (setB [this val] (set! b val)))


;; defrecord
;; ----------------------------------------------------------------------------

;; `deftype` doesn't provide much out of the box. Often what you want to do is
;; have a domain object that acts more or less like a map. This is what
;; `defrecord` is for.

;; Like `deftype`, it's idiomatic to use CamelCase to name a `defrecord`.

(defrecord Person [first last])

;; You can construct an instance in the usual way.

(Person. "Bob" "Smith")

;; Or you can use the provided constructors.

(->Person "Bob" "Smith")

(map->Person {:first "Bob" :last "Smith"})

;; It's considered idiomatic (and recommended) to define a factory function
;; which returns the created instance of a defrecord/deftype. It's idiomatic to use
;; dash-case for factories names.

(defn person [first last]
  (->Person first last))

;; records work like maps

(seq (person "Bob" "Smith"))

(:first (person "Bob" "Smith"))

(keys (person "Bob" "Smith"))

(vals (person "Bob" "Smith"))

;; both deftype and defrecord are open to dynamic extensions (i.e. open class)

(keys (assoc (person "Bob" "Smith") :age 18))


;; Records & Protocols
;; ----------------------------------------------------------------------------

;; You can extend a defrecord to satisfy a protocol as you do with deftype.

(extend-type Person
  MyProtocol
  (awesome [this]
    (str (:last this) ", " (:first this))))

(awesome (person "Bob" "Smith"))

(satisfies? MyProtocol (person "Bob" "Smith"))

;; Or you can extend a protocol on a defrecord.

(extend-protocol MyProtocol
  Person
  (awesome [this]
    (str (:last this) ", " (:first this))))

(awesome (person "Bob" "Smith"))

(satisfies? MyProtocol (person "Bob" "Smith"))

;; If you need a more sophisticated form of polymorphism consider multimethods.

;; If you mix types/records with protocols you are modeling your problem with an
;; object oriented approach, which is sometimes useful.

;; Note ClojureScript does not offer a direct form of inheritance. Instead,
;; reuse/extension by composition is encouraged. It's best to avoid
;; deftype/defrecord and model your problem with plain maps. You can easily
;; switch to records later on down the line.

(defrecord Contact [person email])

;; Even if it's not required, remember to define a factory function to create
;; instances of the new Contact record type by internally calling the factory
;; function for the Person record type.

(defn contact [first last email]
  (->Contact (person first last) email))

(contact "Bob" "Smith" "bob.smith@acme.com")

;; And extend the protocol on defrecord as well.

(extend-protocol MyProtocol
  Contact
  (awesome [this]
    (str (awesome (:person this)) ", " (:email this))))

(awesome (contact "Bob" "Smith" "bob.smith@acme.com"))

;; To change the value of a nested key you use 'assoc-in', like with maps.

(assoc-in (contact "Bob" "Smith" "bob.smith@acme.com")
          [:person :first] "Robert")

;; If you need to use the previous value of a nested field for calculating the
;; new one, you can use 'update-in', like with maps.

(update-in (contact "Bob" "Smith" "bob.smith@acme.com")
           [:person :first] #(string/replace %1 #"Bob" %2) "Robert")

;; As said, the main difference with the majority of OO languages is that your
;; instances of deftypes/defrecords are immutable.

(def bob (contact "Bob" "Smith" "bob.smith@acme.com"))

(update-in bob [:person :first] #(string/replace %1 #"Bob" %2) "Robert")

(get-in bob [:person :first])


;; JavaScript Interop
;; ============================================================================

;; Property Access
;; ----------------------------------------------------------------------------

(def a-date (js/Date.))

;; You can access properties with the `.-` property access syntax.

(.-getSeconds a-date)


;; Method Calls
;; ----------------------------------------------------------------------------

;; Methods can be invoked with the `.` syntax.

(.getSeconds a-date)

;; The above desugars into the following.

(. a-date (getSeconds))

;; For example, you can write a `console.log` call like so.

(. js/console (log "Interop!"))


;; Primitive Array Operations
;; ----------------------------------------------------------------------------

;; When writing performance sensitive code, sometimes dealing with mutable
;; arrays is unavoidable. ClojureScript provides a variety of functions for
;; creating and manipulating JavaScript arrays.

;; You can make an array of specific size with `make-array`

(make-array 32)

;; You can access an element of an array with `aget`.

(aget #js ["one" "two" "three"] 1)

;; You can access nested arrays with `aget`.

(aget #js [#js ["one" "two" "three"]] 0 1)

;; You can set the contents of an array with aset.

(def yucky-stuff #js [1 2 3])

(aset yucky-stuff 1 4)

yucky-stuff
