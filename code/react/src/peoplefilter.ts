// Component hierarchy:
// - PeopleFilter
// 	- FilterPanel
// 	- PeopleList
// 		- PersonItem

var PeopleFilter = React.createClass({
	render: function() {
		return (
			<div className="peopleFilter"></div>
		);
	}
});

// People data
var PEOPLE = [
	{name: 'Rok Krulex', image: 'http://media.licdn.com/mpr/mpr/shrink_500_500/p/8/005/04c/25a/2dadc78.jpg'},
	{name: 'Ana Krulex', image: 'http://media.licdn.com/mpr/mpr/shrink_500_500/p/6/005/087/28b/3138dc4.jpg'}
];

React.render(
	<PeopleFilter />,
	document.getElementById('content')
);
