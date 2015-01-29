var SearchBox = React.createClass({ displayName: "SearchBox", handleUserInput: function (input) {
    this.setState({ searchString: input });
}, getInitialState: function () {
    return {
        searchString: ''
    };
}, render: function () {
    return (React.createElement("div", { className: "searchBox" }, React.createElement(SearchPanel, { searchString: this.state.searchString, onUserInput: this.handleUserInput }), React.createElement(ProductList, { products: this.props.products, searchString: this.state.searchString })));
} });
var SearchPanel = React.createClass({ displayName: "SearchPanel", handleChange: function () {
    this.props.onUserInput(this.refs.searchStringInput.getDOMNode().value);
}, render: function () {
    return (React.createElement("form", { className: "searchPanel" }, React.createElement("input", { type: "text", placeholder: "Search...", value: this.props.searchString, ref: "searchStringInput", onChange: this.handleChange })));
} });
var ProductList = React.createClass({ displayName: "ProductList", render: function () {
    var productItems = this.props.products.filter(function (product) {
        return product.name.indexOf(this.props.searchString) !== -1;
    }.bind(this)).map(function (product) {
        return (React.createElement(ProductItem, { product: product }));
    });
    return (React.createElement("div", { className: "productList" }, productItems));
} });
var ProductItem = React.createClass({ displayName: "ProductItem", render: function () {
    return (React.createElement("div", { className: "productItem" }, this.props.product.name, "  ", this.props.product.price));
} });
var PRODUCTS = [
    { category: "Sporting Goods", price: "$49.99", stocked: true, name: "Football" },
    { category: "Sporting Goods", price: "$9.99", stocked: true, name: "Baseball" },
    { category: "Sporting Goods", price: "$29.99", stocked: false, name: "Basketball" },
    { category: "Electronics", price: "$99.99", stocked: true, name: "iPod Touch" },
    { category: "Electronics", price: "$399.99", stocked: false, name: "iPhone 5" },
    { category: "Electronics", price: "$199.99", stocked: true, name: "Nexus 7" }
];
React.render(React.createElement(SearchBox, { products: PRODUCTS }), document.getElementById('content'));
