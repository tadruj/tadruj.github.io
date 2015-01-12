// Identity monad - the monad that doesn't need to be used, because we're already using it with pure functions.
// https://hackage.haskell.org/package/mtl-1.1.0.2/docs/Control-Monad-Identity.html

function compose(f, g) {
	return function(x) {
		return f(g(x));
	}
}

function increment(x) {
	return x + 1;
}

function multiply(x) {
	return x * x;
}

var t1 = compose(multiply, increment); console.log('t1: ' + t1(2));
var t2 = compose(increment, t1); console.log('t2: ' + t2(2));

function bind(f) {
	return function(x) {
		return f(x);
	}
}

function unit(x) {
	return x;
}

var t3 = compose(bind(multiply), bind(increment)); console.log('t3: ' + t3(2));
var t4 = compose(bind(increment), t1); console.log('t4: ' + t4(2));

// Proving the monad

console.log('  left unit equals: ', // left side: unit acts as neutral element of bind
	bind(increment)(unit(1)) 											// bind(unit(x), f) ==> bind(f)(unit(x))
, '====' ,																// ≡
	increment(1)														// f(x)
);

console.log(' right unit equals: ', // right side: unit acts as neutral element of bind
	bind(unit)(unit(1))													// bind(m, unit) ==> bind(unit)(m)
, '====' ,																// ≡
	unit(1)																// m
);

console.log('associative equals: ', // chaining is the same as nesting
	bind(increment)(bind(multiply)(unit(3))) 							// bind(bind(m, f), g) ==> bind(g)(bind(f)(m))
, '====' , 																// ≡
	bind(function(x) { return bind(increment)(multiply(x)) })(unit(3))	// bind(m, x ⇒ bind(f(x), g)) ==> :)
);

// Writer monad - it collects logging data as the functions execute

// number -> [number, list]
function wIncrement(x) {
	return [x + 1, ['wIncrement']];
}

// number -> [number, list]
function wMultiply(x) {
	return [x * x, ['wMultiply']];
}

// (number -> [number, list]) -> ([number, list] -> [number, list])
function wBind(f) {
	return function(input) {
		var output = f(input[0]);
		return [output[0], input[1].concat(output[1])];
	}
}

var t5 = compose(wBind(wIncrement), wBind(wMultiply)); console.log('t5: ', t5([ 2, [] ]));
var t6 = compose(wBind(wMultiply), t5); console.log('t6: ', t6([ 2, [] ]));

// number -> [number, list]
function wUnit(x) {
	return [x, []];
}

var t7 = compose(wBind(wMultiply), t5); console.log('t7: ', t7(wUnit(2)));
var t8 = compose(wBind(wIncrement), wBind(wMultiply)); console.log('t8: ', t8(wUnit(2)));

// number -> [number, list]
function wSine(x) { return wUnit(Math.asin(x)); };

var t9 = compose(wBind(wIncrement), wBind(wSine)); console.log('t9: ', t9(wUnit(0)));

// (number -> number) -> (number -> [number, list])
function wLift(f) {
	return function(x) {
		return wUnit(f(x))
	}
}

var wAsine = wLift(Math.cos)
var t10 = compose(wBind(wAsine), wBind(wSine)); console.log('t10: ', t10(wUnit(0)));

console.log('=======');
console.log('',
	compose(wLift, wBind(wUnit)),
	'====',
	wUnit(1)
);
console.log('=======');

// Proving the Writer monad

console.log('  left unit equals: ', // left side: unit acts as neutral element of bind
	wBind(wIncrement)(wUnit(1)) 											// bind(unit(x), f) ==> bind(f)(unit(x))
, '====' ,																	// ≡
	wIncrement(1)															// f(x)
);

console.log(' right unit equals: ', // right side: unit acts as neutral element of bind
	wBind(wUnit)(wUnit(1))													// bind(m, unit) ==> bind(unit)(m)
, '====' ,																	// ≡
	wUnit(1)																// m
);

console.log('associative equals: ', // chaining is the same as nesting
	wBind(wIncrement)(wBind(wMultiply)(wUnit(3))) 							// bind(bind(m, f), g) ==> bind(g)(bind(f)(m))
, '====' , 																	// ≡
	wBind(function(x) { return wBind(wIncrement)(wMultiply(x)) })(wUnit(3)) // bind(m, x ⇒ bind(f(x), g)) ==> :)
);

// State monad, specifically
// Random monad - it generates the random number based on the seed, which is passed along
// http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html

function random(seed) { // pure random function which always returns the same random number for the same seed
	return (function(x) { return x - Math.floor(x) })(Math.sin(seed + 1) * 10000);
}

console.log(
	random(12)
);

// (seed:number -> [random_number:number, seed:number]) -> ([random_number:number, seed:number] -> [random_number:number, next_seed:number])
function rBind(f) {
	return function(input) {
		var _ignored_input = input[0],
			seed = input[1];
		output = f(seed);
		var random_number = output[0],
			next_seed = random_number;
		// Next seed could be represented by more sophisticated function than just a copy of the random number
		// until the next_seed generation algorithm is coded in the function, we don't need to pass it along
		// 	because it is not a side effect
		return [ random_number, next_seed ]
	}
}

// [seed] -> [_ignored_number, seed]
function rUnit(v) {
	return [v,v];
}

console.log(
	rUnit(0)
);

// (number -> number) -> ([number, seed] -> [number, seed])
function rLift(f) {
	return function(v) {
		return rUnit(f(v))
	}
}

// seed -> random_number, seed
var rRandom = rLift(random);

// TODO: we don't need compose() from the beginning.
console.log(
	rBind(rRandom)([0, 12]),
	compose(rBind(rRandom), rBind(rRandom))([0, 12]),
	rBind(rRandom)(rBind(rRandom)([0, 12])),
	rBind(rRandom)(rBind(rRandom)(rBind(rRandom)([0, 12])))
);

// Proving the State monad

console.log('  left unit equals: ', // left side: unit acts as neutral element of bind
	rBind(rRandom)(rUnit(1)) 											// bind(unit(x), f) ==> bind(f)(unit(x))
, '====' ,																// ≡
	rRandom(1)															// f(x)
);

console.log(' right unit equals: ', // right side: unit acts as neutral element of bind
	rBind(rUnit)(rUnit(1))													// bind(m, unit) ==> bind(unit)(m)
, '====' ,																	// ≡
	rUnit(1)																// m
);

console.log('associative equals: ', // chaining is the same as nesting
	rBind(rRandom)(rBind(rRandom)(rUnit(3))) 							// bind(bind(m, f), g) ==> bind(g)(bind(f)(m))
, '====' , 																// ≡
	rBind(function(x) { return rBind(rRandom)(rRandom(x)) })(rUnit(3)) 	// bind(m, x ⇒ bind(f(x), g)) ==> :)
);

var composeMulti = function() {
    var funcs = arguments;
    return function() {
        var args = arguments;
        for (var i = funcs.length; i--; i == 0) {
            args = [funcs[i].apply(this, args)];
        }
        return args[0];
    };
};

// Mixing monads

var rIncrement = rLift(increment)

console.log(
	rBind(rRandom)(rUnit(12)),
	rBind(rIncrement)(rBind(rIncrement)(rBind(rRandom)(rUnit(12))))
);

// TODO:
// Loose compose or let it return a function
// Do more mix and match of different monads
// Implement few in OCaml
// Implement few in TypeScript


