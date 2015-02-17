/** @jsx React.DOM */

var LocationPosts = React.createClass({
  getInitialState: function() {
    // Perhaps replace this
    // DO NOT REFERENCE THIS PROP LATER
    return { posts: this.props.posts }
  },

  render: function() {
    var postNodes = this.state.posts.map(function(post) {
      return <Post 
        location={post.spotted_at}
        description={post.description}
        content={post.content}
        comments={post.comments}
        age={post.age} />;
    })

    return (
      <div id="react-location-posts-container">
        { postNodes }
      </div>
    );
  }
});

var Post = React.createClass({
  render: function() {

    return (
      <div className="post">
        <h4 className="post-location">{ this.props.location }</h4>
        <h5 className="post-description">{ this.props.description }</h5>
        <p className="post-content">{ this.props.content }</p>
      
        <CommentList comments={this.props.comments} />
        <p className="post-links">
          {this.props.age} ago | 
          <a className="post-links-comment" href="#">Comment</a> | 
          <a className="post-links-report" href="#">Report</a>
        </p>
      </div>
    )
  }
});

var CommentList = React.createClass({
  render: function() {
    var commentNodes = this.props.comments.map(function(comment) {
      return <Comment
        author={comment.author_name}
        content={comment.content} />
    })

    return(
      <div className="comment-container">
        <div className="comment-list">
          { commentNodes }
        </div>
      </div>
    );
  }
});

var Comment = React.createClass({
  render: function() {
    return (
      <p className="comment">
        <span className="comment-author">{this.props.author} says:</span> {this.props.content}
      </p>
    );
  }
});