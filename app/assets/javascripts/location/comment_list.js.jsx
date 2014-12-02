/** @jsx React.DOM */

var CommentList = React.createClass({
  render: function() {
    var commentNodes = this.props.comments.map(function (comment) {
      return (
        <Comment author={comment.author_name} content={comment.content} key={comment.id}/>
      )
    })

    return (
      <div className="comment-list">
        {commentNodes}
      </div>
    );
  }
});