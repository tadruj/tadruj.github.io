// Write a function capitals that takes a single string (word) as argument. The functions must return an ordered list containing the indexes of all capital letters in the string.

var capitals = function (word) {
	return Array.prototype.map.call(word, function(c, i){
		if (c === c.toUpperCase()) return i;
	}).filter(function(n){
		return n !== undefined;
	});
};

console.log(capitals('FrkASkroZ'));
// Test.assertSimilar( capitals('FrkASkroZ'), [0,3,4,8] );

