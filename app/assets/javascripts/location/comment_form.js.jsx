/** @jsx React.DOM */

var CommentForm = React.createClass({
  handleSubmit: function(event) {
    this.props.handleCommentSubmit(event);
  },
  render: function() {
    var path = postsPath + "/" + this.props.postId + "/comments";

    return (
      <form accept-charset="UTF-8" action={path} className="new-comment" method="post" onSubmit={this.handleSubmit} >
        <input type="text" name="comment" />
        <input type="submit" value="Submit" />
      </form>
    )
  }
})
