/** @jsx React.DOM */

var LocationDisplay = React.createClass({
  getInitialState: function() {
    return {posts: []};
  },
  componentDidMount: function() {
    this.loadPostsFromServer(this.props.batchSize);
    setInterval(this.loadPostsFromServer, this.props.pollInterval);
    $(window).on('scroll', this.handleScroll);
    $('form[id=post-form]').on('submit', this.handlePostSubmit);
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
    if ( $(window).scrollTop() == $(document).height() - $(window).height()) {
      newSize = this.state.posts.length + this.props.batchSize;
      this.loadPostsFromServer(newSize);
    };
  },
  handlePostSubmit: function(event) {
    event.preventDefault();
    var location = this;
    var $form = $(event.target);

    console.log(this.props.url);
    $.ajax({
      type: "POST",
      url: this.props.url,
      data: $form.serializeArray()
    })
    .done(function(response) {
      newPost = response.post;
      location.setState({posts: [newPost].concat(location.state.posts)});
    })
    .fail(function(response) {
      var errors = response.responseJSON.errors
    })
  },
  render: function() {
    return (
      <div id="location-container">
        <Sidebar />
        <div id="location_posts">
            <PostList posts={this.state.posts} />
        </div>
      </div>
    )
  }
});

var Sidebar = React.createClass({
  render: function() {
    return(
      <div id="sidebar">
        <div id="sidebar-container">
          <h1 id="badge">afar</h1>
          <h2 id="location">{locationName}</h2>
          <SidebarPostForm />
        </div>
      </div>
    )
  }
});

var SidebarPostForm = React.createClass({
  render: function() {
    return (
      <form accept-charset="UTF-8" action={postsPath} className="new_post" id="post-form" method="post">
        <div className="post-form-select">
          <label for="post_gender">Gender</label><br/>
          <div className="post-form-select-background">
            <select id="post_gender" name="post[gender]">
              <option value=""></option>
              <option value="Male">Male</option>
              <option value="Female">Female</option></select>
            </div>
        </div>

        <div className="post-form-select">
          <label for="post_hair">Hair</label><br/>
          <div className="post-form-select-background"><select id="post_hair" name="post[hair]"><option value=""></option>
            <option value="Brown">Brown</option>
            <option value="Black">Black</option>
            <option value="Blonde">Blonde</option>
            <option value="Red">Red</option></select></div>
          </div>

        <label for="post_spotted_at">Location</label>
        <input id="post_spotted_at" name="post[spotted_at]" type="text"/><br/>

        <label for="post_content">Message</label>
        <textarea id="post_content" name="post[content]" rows="4"></textarea><br/>

        <input type="submit" value="Submit!"/>
      </form>
    )
  }
})

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

var reactLocationReady = function() {
  React.renderComponent(
    <LocationDisplay url={postsPath} pollInterval={40000} batchSize={10} />,
    document.body
  );
}
