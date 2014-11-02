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
    this.loadPostsFromServer(this.props.batchSize);
    setInterval(this.loadPostsFromServer, this.props.pollInterval);
    window.addEventListener('scroll', this.handleScroll);
  },
  loadPostsFromServer: function(size) {
    var size = size || this.state.posts.length
    
    $.ajax({
      url: this.props.url,
      data: { batch_size: size },
      dataType: 'json',
      success: function (data) {
        this.setState({posts: data.posts});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  handleScroll: function() {
    if ( $(window).scrollTop() >= $(document).height() - $(window).height()) {
      newSize = this.state.posts.length + this.props.batchSize;
      this.loadPostsFromServer(newSize);
    };
  },
  render: function() {
    return (
      <div className="postBox" ref="">
        <PostList posts={this.state.posts} />
      </div>
    );
  }
});



var reactReady = function() {
  React.renderComponent(
    <PostBox url={postsPath} pollInterval={4000} batchSize={10} />,
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
    newPost = response.post;
    // Implement displaying new post
  })
  .fail(function(response) {
    var errors = response.responseJSON.errors
    // Implement error display
  });
}

$(".location_posts").ready(function() {
  reactReady();

  $("form").on("submit", function() {
    event.preventDefault();
    submitPost(this);
  });

  $(window).scroll( function() {
    if ( $(window).scrollTop() == $(document).height() - $(window).height()) {
      
    };
  });


});
