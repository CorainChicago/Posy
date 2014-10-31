/** @jsx React.DOM */
var Post = React.createClass({
  render: function() {
    return (
      <div className="post">
        <p className="hair">Hair: {this.props.hair}</p>
        <p className="location">Location: {this.props.location}</p>
        <p className="gender">Gender: {this.props.gender}</p>
        <p className="content">Content: {this.props.content}</p>
      </div>
    );
  }
});

var PostList = React.createClass({
  render: function() {
    var postNodes = this.props.posts.map(function (post, index) {
      return (
        <Post hair={post.hair} location={post.spotted_at} gender={post.gender} content={post.content} key={index} />
      )
    });

    return (
      <div className="postList">
        {postNodes}
      </div>
    );
  }
});

var PostBox = React.createClass({
  getInitialState: function() {
    return {posts: []};
  },
  componentDidMount: function() {
    this.loadPostsFromServer();
  },
  loadPostsFromServer: function() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      success: function (data) {
        this.setState({posts: data.posts});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  render: function() {
    return (
      <div className="postBox">
        <PostList posts={this.state.posts} />
      </div>
    );
  }
});

var ready = function() {
  posts_path = window.location.pathname + "/posts"

  React.renderComponent(
    <PostBox url={posts_path} />,
    document.getElementById('location_posts')
  );
};

$(".location_posts").ready(ready);