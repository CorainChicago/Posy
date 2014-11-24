/** @jsx React.DOM */

/* REACT STRUCTURE 
  -LocationDisplay
    -Sidebar
      -SidebarPostForm
    -PostList
      -Post
        -CommentForm
        -CommentList
          -Comment
*/

var LocationDisplay = React.createClass({
  getInitialState: function() {
    return {
      posts: [],
      numPosts: this.props.batchSize
    };
  },
  componentDidMount: function() {
    this.loadPostsFromServer(this.props.batchSize);
    setInterval(this.loadPostsFromServer, this.props.pollInterval);

    $(window).on('scroll', this.handleScroll);
    $('form[id=post-form]').on('submit', this.handlePostSubmit);
  },
  loadPostsFromServer: function() {
    var size = this.state.numPosts;

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
      this.setState({ numPosts: newSize})
      this.loadPostsFromServer();
    };
  },
  handlePostSubmit: function(event) {
    event.preventDefault();
    var location = this;
    var $form = $(event.target);

    $.ajax({
      type: "POST",
      url: this.props.url,
      data: $form.serializeArray()
    })
    .done(function(response) {
      // newPost = response.post;
      // newPost.age = "1 second";
      // $("html, body").animate({ scrollTop: 0 }, "fast", function() {
      //   location.setState({posts: [newPost].concat(location.state.posts)});
      // });
      console.log(response.posts[0]);
      location.setState({posts: response.posts})
    })
    .fail(function(response) {
      var errors = response.responseJSON.errors
      // implement error message display
    })
  },
  handleCommentSubmit: function(event) {
    event.preventDefault();
    var $form = $(event.target);
    var $input = $form.find('input[type=text]');
    var comment = $input.val();
    var path = $form.attr("action");
    var that = this;

    $.ajax({
      method: "POST",
      data: {
        "comment" : comment,
        "batchSize" : this.state.numPosts 
      },
      url: path
    })
    .done(function(response) {
      that.setState({posts: response.posts});
      $input.val("");
      $form.hide();
    })
    .error(function(response) {
      // Implement some sort of message?
      that.loadPostsFromServer();
    });
  },
  handleFlagging: function(post, path) {
    var flagPath = this.props.url + path
    $.ajax({
      url: flagPath,
      method: "POST"
    })
    this.loadPostsFromServer();
  },
  render: function() {
    return (
      <div id="location-container">
        <Sidebar />
        <div id="location-posts">
            <PostList handleFlagging={this.handleFlagging} handleCommentSubmit={this.handleCommentSubmit} posts={this.state.posts} />
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
      <form accept-charset="UTF-8" action={postsPath} className="new-post" id="post-form" method="post">
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
    var passFlaggingUp = this.props.handleFlagging;
    var passCommentUp = this.props.handleCommentSubmit;
    var toggleForms = this.toggleCommentForms;
    var postNodes = this.props.posts.map(function (post) {
      return (
        <Post 
          hair={post.hair} 
          location={post.spotted_at} 
          gender={post.gender} 
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
        {postNodes}
      </div>
    );
  }
});

var Post = React.createClass({
  handleFlaggingClick: function() {
    var flagPath = "/" + this.props.key + "/flag";
    this.props.handleFlagging(this, flagPath);
  },
  showCommentForm: function() {
    var $form = $(this.refs.newComment.getDOMNode());
    if ($form.css('display') == 'none') {
      $('form.new-comment:visible').hide('fast');
      $form.show('fast');
      var $input = $form.find('input[type=text]');
      $input.focus();
    }
    return false; // prevents page from scrolling up
  },
  render: function() {

    return (
      <div className="post">
        <div className="post-content">
          <p className="location">at {this.props.location}</p>
          <p className="hair">{this.props.hair}-haired </p>
          <p className="gender">{this.props.gender}</p>
          <p className="content">{this.props.content}</p>
        </div>
        <div className="comment-section">
          <CommentList comments={this.props.comments} />
          <CommentForm ref="newComment" postId={this.props.key} handleCommentSubmit={this.props.handleCommentSubmit} />
        </div>
        <p className="post-links">{this.props.age} ago |
        <a href="#" className="add-comment" onClick={this.showCommentForm}> Comment </a>|
        <a href="#" className="report-post" onClick={this.handleFlaggingClick}> Report </a></p>
      </div>
    );
  }
});

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

var Comment = React.createClass({
  render: function() {
    return (
      <div className="comment">
        <p className="comment-content">
          <span className="comment-author">{this.props.author} says: </span>
          {this.props.content}
        </p>
      </div>
    )
  }
});

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

var reactLocationReady = function() {
  React.renderComponent(
    <LocationDisplay url={postsPath} pollInterval={500000} batchSize={10} />,
    document.body
  );
}
