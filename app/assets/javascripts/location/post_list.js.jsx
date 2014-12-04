/** @jsx React.DOM */

PostList = React.createClass({
  render: function() {
    var passFlaggingUp = this.props.handleFlagging;
    var passCommentUp = this.props.handleCommentSubmit;
    var toggleForms = this.toggleCommentForms;
    var horizontal = this.props.horizontal;
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
          handleCommentSubmit={passCommentUp} 
          horizontal={horizontal} />
      )
    });

    return (
      <div className="post-list">
        <h2 id="listLocation" className="hide-on-small">
          <span id="listLocationSpan">{locationName}</span>
        </h2>
        {postNodes}
        <svg height="24" width="24" id="exhausted-circle">
          <circle cx="12" cy="12" r="4" stroke="none" stroke-width="1" fill="#96281B" />
        </svg>
      </div>
    );
  }
});