var unit = function(value) { // wraps the value to the monadic value = function that returns the value
	return function() { return value };
}; // mv

var bind = function(mv, f) { // executes the function on the monadic value = unwraps the value and applies the function
	return f(mv());
}; // v

var uSweet = function(value) {
	return unit("sweet " + value);
}; // mv

console.log(
	bind(unit('candy'), uSweet)
);

console.log(
	bind(unit('candy'), uSweet)()
);

var mSweet = function(mv) {
	return bind(mv, function(value) {
		return unit("sweet " + value);
	});
};

console.log(
	mSweet(unit('candy'))()
);

// lift is used to tell the monadic function to operate on normal value
var lift = function(f) {
	return function(mv) {
		return bind(mv, function() {
			return unit(f(mv()));
		});
	};
};

var sweet = function(value) {
	return "sweet " + value;
};

console.log(
	lift(sweet)(unit('candy'))()
);

var increment = function(value) {
	return value + 1;
};

var multiply = function(value) {
	return value * value;
};

console.log(
	lift(multiply)(unit(2))() 
);

console.log(
	lift(increment)(unit(0))() 
);

var mIncrement = function(mv) {
	return unit(bind(mv, increment));
};

var mMultiply = function(mv) {
	return unit(bind(mv, multiply));
};

console.log(
	mMultiply(mIncrement(mMultiply(mIncrement(unit(1)))))()
);

// Proving the monads

console.log('  left unit equals: ', // left side: unit acts as neutral element of bind
	bind(unit("candy"), sweet) 
, '====' ,
	sweet("candy")
);

console.log(' right unit equals: ', // right side: unit acts as neutral element of bind
	bind(unit("candy"), unit) 
, '====' ,
	unit("candy")
);

console.log('associative equals: ', // chaining is the same as nesting
	bind(unit(bind(unit(1), increment)), multiply)
, '====' ,
	bind(unit(1), function(x) { return bind(unit(increment(x)), multiply) })
);
