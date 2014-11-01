/** @jsx React.DOM */
var postsPath = window.location.pathname + "/posts";

var Post = React.createClass({
  render: function() {
    return (
      <div className="post">
        <p className="location">{this.props.location}: </p>
        <p className="hair">{this.props.hair}-haired </p>
        <p className="gender">{this.props.gender}</p>
        <p className="content">{this.props.content}</p>
        <a className="post-flag" href="#" title="Flag as inappropriate">X</a>
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

var react_ready = function() {
  React.renderComponent(
    <PostBox url={postsPath} />,
    document.getElementById('location_posts')
  );
};

var submitPost = function(form) {
  $.ajax({
    type: "POST",
    url: postsPath,
    data: $(form).serializeArray()
  })
  .done(function(response) {
    newPost = response.post
    // Implement displaying new post
  })
  .fail(function(response) {
    var errors = response.responseJSON.errors
    // Implement error display
  });
}

$(".location_posts").ready(function() {
  react_ready();

  $("form").on("submit", function() {
    event.preventDefault();
    submitPost(this);
  })
});



