// Component hierarchy:
// - PeopleFilter
// 	- FilterPanel
// 	- PeopleList
// 		- PersonItem

var PeopleFilter = React.createClass({
	getInitialState: function() {
		return {
			filterString: ''
		}
	},
	render: function() {
		return (
			<div className="peopleFilter">
				<FilterPanel filterString={this.state.filterString} />
				<PeopleList filterString={this.state.filterString} people={this.props.people} />
			</div>
		);
	}
});

var FilterPanel = React.createClass({
	render: function() {
		return (
			<div className="fitlerPanel">
				<input type="text" placeholder="Filter..." value={this.props.filterString} />
			</div>
		);
	}
});

var PeopleList = React.createClass({
	render: function() {
		var peopleList = this.props.people.filter(function(person) {
			return (
				person.name.indexOf(this.props.filterString) !== -1
			);
		}.bind(this)).map(function(person) {
			return (
				<PersonItem person={person} />
			)
		});
		return (
			<div className="peopleList">
				{peopleList}
			</div>
		);
	}
});

var PersonItem = React.createClass({
	render: function() {
		return (
			<div className="personItem">
				<img src={this.props.person.image} width="150" />
				{this.props.person.name}
			</div>
		)
	}
});

// People data
var PEOPLE = [
	{name: 'Rok Krulex', image: 'http://avatars0.githubusercontent.com/u/570868?v=3&s=480'},
	{name: 'Ana Krulex', image: 'http://lh6.googleusercontent.com/-lGzajkSUsYk/AAAAAAAAAAI/AAAAAAAAoEE/xOYnbXUneHs/photo.jpg'}
];

React.render(
	<PeopleFilter people={PEOPLE} />,
	document.getElementById('content')
);
