var wrap = function(value) {
	return function() { return value };
};

var bind = function(mv, f) {
	return f(mv());
};

var more = function(value) {
	return wrap("more " + value);
};

console.log(
	bind(wrap('candy'), more)
);

console.log(
	bind(wrap('candy'), more)()
);

var mMore = function(mv) {
	return bind(mv, function(value) {
		return wrap("more " + value);
	});
};

console.log(
	mMore(wrap('candy'))()
);

var lift = function(f) {
	return function(mv) {
		return bind(mv, function() {
			return wrap(f(mv()));
		});
	};
};

var normalMore = function(value) {
	return "more " + value;
};

console.log(
	lift(normalMore)(wrap('candy'))()
);
