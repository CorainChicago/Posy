/** @jsx React.DOM */

var Comment = React.createClass({
  render: function() {
    return (
      <div className="comment">
        <p className="comment-content">
          <span className="comment-author">{this.props.author} says: </span>
          {this.props.content}
        </p>
      </div>
    )
  }
});