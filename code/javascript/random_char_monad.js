function RandomChar() {
    var random = Math.round(Math.random(Date.now()));
    if(random > 0.5) this.value = "a"; else this.value = "b";
    console.log('Random(): ', random, this.value);
}

RandomChar.prototype.bind = function (transform) {
    return transform(this.value);
};

var result = new RandomChar().bind(function (value) {
	return new RandomChar().bind(function(value2) {
		return new RandomChar().bind(function(value3) {
			return value3 + value2 + value;
		});
	});
});

console.log('result:', result);

// monadic value = function that closes over the value
// 