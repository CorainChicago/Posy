/** @jsx React.DOM */
var Post = React.createClass({
  render: function() {
    return (
      <div className="post">
        <p className="content">
          {this.props.content}
        </p>
      </div>
    );
  }
});

var PostList = React.createClass({
  render: function() {
    var postNodes = this.props.posts.map(function (post, index) {
      return (
        <Post content={post.content} key={index} />
      )
    });

    return (
      <div className="postList">
        {postNodes}
      </div>
    );
  }
});

var ready = function() {
  var faked = [
    { content: "I'm a post!"},
    { content: "I'm another post!"}
  ]

  React.renderComponent(
    <PostList posts={faked} />,
    document.getElementById('posts')
  );
};

$(document).ready(ready);