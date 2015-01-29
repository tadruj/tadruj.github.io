var SearchBox = React.createClass({
	handleUserInput: function(input) {
		this.setState({searchString: input});
	},
	getInitialState: function() {
		return {
			searchString: ''
		}
	},
	render: function() {
		return (
			<div className="searchBox">
				<SearchPanel searchString={this.state.searchString} onUserInput={this.handleUserInput} />
				<ProductList products={this.props.products} searchString={this.state.searchString} />
			</div>
		)
	}
});

var SearchPanel = React.createClass({
	handleChange: function() {
		this.props.onUserInput(this.refs.searchStringInput.getDOMNode().value);
	},
	render: function() {
		return (
			<form className="searchPanel">
				<input type="text" placeholder="Search..." value={this.props.searchString} ref="searchStringInput" onChange={this.handleChange} />
			</form>
		)
	}
});

var ProductList = React.createClass({
	render: function() {
		var productItems = this.props.products.filter(function(product) {
			return product.name.indexOf(this.props.searchString) !== -1;
		}.bind(this))
		.map(function(product) {
			return (
				<ProductItem product={product} />
			)
		});
		return(
			<div className="productList">
				{productItems}
			</div>
		)
	}
});

var ProductItem = React.createClass({
	render: function() {
		return (
			<div className="productItem">
				{this.props.product.name}
				&nbsp;&nbsp;
				{this.props.product.price}
			</div>
		)
	}
});

var PRODUCTS = [
  {category: "Sporting Goods", price: "$49.99", stocked: true, name: "Football"},
  {category: "Sporting Goods", price: "$9.99", stocked: true, name: "Baseball"},
  {category: "Sporting Goods", price: "$29.99", stocked: false, name: "Basketball"},
  {category: "Electronics", price: "$99.99", stocked: true, name: "iPod Touch"},
  {category: "Electronics", price: "$399.99", stocked: false, name: "iPhone 5"},
  {category: "Electronics", price: "$199.99", stocked: true, name: "Nexus 7"}
];

React.render(
  <SearchBox products={PRODUCTS} />  
  ,
  document.getElementById('content')
);
