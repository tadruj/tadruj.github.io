var LikeButton = React.createClass({
	toggleLike: function () {
		this.setState({liked: !this.state.liked});
	},
	getInitialState: function () {
		return {
			liked: false
		}
	},
	render: function() {
		return (
			<p onClick={this.toggleLike}>
				You {this.state.liked ? 'liked' : "didn't like"} this.
			</p>
		);
	}
});

React.render(
	<LikeButton />,
	document.body
);