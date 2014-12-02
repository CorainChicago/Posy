/** @jsx React.DOM */

PostList = React.createClass({
  render: function() {
    var passFlaggingUp = this.props.handleFlagging;
    var passCommentUp = this.props.handleCommentSubmit;
    var toggleForms = this.toggleCommentForms;
    var postNodes = this.props.posts.map(function (post) {
      return (
        <Post 
          location={post.spotted_at} 
          desc={post.description}
          content={post.content}
          age={post.age} 
          key={post.id}
          comments={post.comments} 
          handleFlagging={passFlaggingUp}
          handleCommentSubmit={passCommentUp} />
      )
    });

    return (
      <div className="post-list">
        <h2 id="listLocation">{locationName}</h2>
        {postNodes}
      </div>
    );
  }
});