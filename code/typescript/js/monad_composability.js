// The goal is to have all the functionality wired up
// not necessarily capturing all the side effects
// and at the end applying the function and collecting the value and optionally side effects

function compose(f, g) {
	return function(x) {
		return f(g(x));
	}
}

function increase(x) {
	return x + 1;
}

function multiply(x) {
	return x * x;
}

var t1 = compose(multiply, increase); console.log('t1: ' + t1(2));
var t2 = compose(increase, t1); console.log('t2: ' + t2(2));

function bind(f) {
	return function(x) {
		f(x);
	}
}

function random() {
	return Math.random(Date.now());
}

function unit(x) {
	return x;
}

// all the functions have to return immediately, so they start with return. No sequencing.
