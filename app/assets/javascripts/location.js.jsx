/** @jsx React.DOM */

/* REACT STRUCTURE 
  -LocationDisplay
    -Sidebar
      -PostForm
    -PostList
      -Post
        -CommentForm
        -CommentList
          -Comment
*/

var LocationDisplay = React.createClass({
  getInitialState: function() {
    var horizontal = window.innerWidth > this.props.breakpoint;

    return {
      posts: [],
      horizontal: horizontal,
      exhausted: false // have all posts been retrieved from server?
    };
  },
  componentDidMount: function() {
    this.loadPostsFromServer(this.props.batchSize);
    setInterval(this.loadPostsFromServer, this.props.pollInterval);

    $(window).resize(this.handleResize);
    $(window).on('scroll', this.handleScroll);
  },
  loadPostsFromServer: function() {
    var size = this.state.posts.length + this.props.batchSize
    var that = this;

    $.ajax({
      url: this.props.url,
      data: { batch_size: size },
      dataType: 'json'
    })
    .done(function(response) {
      var posts = response.posts;
      if (posts.length < size) {
        that.setState({posts: posts, exhausted: true});
      }
      else {
        that.setState({posts: posts})
      }
    })
    .fail(function(response) {
      // IMPLEMENT ERROR MESSAGE?
    })
  },
  handleScroll: function() {
    if ( $(window).scrollTop() == $(document).height() - $(window).height()) {
      newSize = this.state.posts.length + this.props.batchSize;
      if (!this.state.exhausted) { 
        this.loadPostsFromServer();
      }
    };
  },
  handlePostSubmit: function(event) {
    event.preventDefault();
    var postForm = this.refs.sidebar.refs.postForm

    if (postForm.validatePresence()) {
      var that = this;
      var $form = $(event.target);
      var postData = $form.serializeArray();
      postForm.disable();

      $.ajax({
        type: "POST",
        url: this.props.url,
        data: postData
      })
      .done(function(response) {
        that.setState({posts: response.posts})
        postForm.reset();
        if (!that.state.horizontal) {
          that.refs.sidebar.handlePostSuccess();
        }
      })
      .fail(function(response) {
        var errors = response.responseJSON.errors
        // implement error message display
        postForm.enable();
      })
    }
  },
  handleCommentSubmit: function(event) {
    event.preventDefault();
    var $form = $(event.target);
    $form.children(":input").prop("disabled", true);
    var $input = $form.find('input[type=text]');
    var comment = $input.val();
    var path = $form.attr("action");
    var that = this;

    $.ajax({
      method: "POST",
      data: {
        "comment" : comment,
        "batchSize" : this.state.posts.length 
      },
      url: path
    })
    .done(function(response) {
      that.setState({posts: response.posts});
      $input.val("");
      $form.children(":input").prop("disabled", false);
      $form.hide();
    })
    .error(function(response) {
      // Implement some sort of message?
      that.loadPostsFromServer();
      $form.children(":input").prop("disabled", false);
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
  handleResize: function(event) {
    var horizontal = window.innerWidth > this.props.breakpoint;
    if (this.state.horizontal && !horizontal) {
      this.setState({horizontal: false})
    }
    else if (!this.state.horizontal && horizontal) {
      this.setState({horizontal: true});
    }
  },
  render: function() {  
    if (this.state.horizontal) {
      return (
        <div id="location-container">
          <Sidebar ref="sidebar" handlePostSubmit={this.handlePostSubmit} />
          <div id="location-posts">
              <PostList handleFlagging={this.handleFlagging} 
                        handleCommentSubmit={this.handleCommentSubmit} 
                        posts={this.state.posts} />
          </div>
        </div>
      )
    }
    else {
      // FIX SIDEBAR REF!!!
      return (
        <div id="location-container">
          <Header ref="sidebar" handlePostSubmit={this.handlePostSubmit} /> 
          <div id="location-posts">
            <PostList handleFlagging={this.handleFlagging} 
                      handleCommentSubmit={this.handleCommentSubmit} 
                      posts={this.state.posts} />
          </div>
        </div>
      )
    }
  }
});

var Sidebar = React.createClass({
  render: function() {
    return(
      <div id="sidebar">
        <div id="sidebar-container">
          <h1 id="badge">Posy</h1>
          <h2 id="location">{locationName}</h2>
          <PostForm ref="postForm" handlePostSubmit={this.props.handlePostSubmit} />
        </div>
      </div>
    )
  }
});

var Header = React.createClass({
  togglePostForm: function() {
    $("#post-form").slideToggle();
    return false;
  },
  handlePostSubmit: function(event) {
    this.props.handlePostSubmit(event);
  },
  handlePostSuccess: function() {
    this.togglePostForm();
    this.refs.postForm.reset();
  },
  render: function() {
    return(
      <div id="header">
        <p id="hmm">!</p>
        <h1 id="badge">Posy</h1>
        <a href="#" id="new-post-button" onClick={this.togglePostForm} >+</a>
        <PostForm ref="postForm" handlePostSubmit={this.handlePostSubmit}/>
      </div>
    )
  }
})

var PostForm = React.createClass({
  validatePresence: function() {
    var valid = true;
    var $location = $('input#post_spotted_at');
    var $content = $('textarea#post_content');

    if ($location.val().trim() === "") {
      $('#location-requirement').fadeIn();
      valid = false;
    }
    if ($content.val().trim() === "") {
      $('#content-requirement').fadeIn();
      valid = false;
    }
    return valid;
  },
  enable: function() {
    $('#post-form').children(":input").prop("disabled", false);
  },
  disable: function() {
    $('#post-form').children(":input").prop("disabled", true);
  },
  reset: function() {
    var form = this.refs.postForm.getDOMNode();
    form.reset();
    this.enable();
  },
  render: function() {
    return (
      <form accept-charset="UTF-8" action={postsPath} id="post-form" method="post" ref="postForm" onSubmit={this.props.handlePostSubmit} >
        <div className="post-form-select">
          <label for="post_gender">Gender</label><br/>
          <div className="post-form-select-background">
            <select id="post_gender" name="post[gender]" ref="genderSelect">
              <option value=""></option>
              <option value="Male">Male</option>
              <option value="Female">Female</option></select>
            </div>
        </div>

        <div className="post-form-select">
          <label for="post_hair">Hair</label><br/>
          <div className="post-form-select-background"><select id="post_hair" name="post[hair]" ><option value=""></option>
            <option value="Brown">Brown</option>
            <option value="Black">Black</option>
            <option value="Blonde">Blonde</option>
            <option value="Red">Red</option></select></div>
          </div>

        <label for="post_spotted_at">Location <span id="location-requirement">(required)</span></label>
        <input id="post_spotted_at" name="post[spotted_at]" type="text" /><br/>

        <label for="post_content">Message <span id="content-requirement">(required)</span></label>
        <textarea id="post_content" name="post[content]" rows="4" ref="contentField"></textarea><br/>

        <input type="submit" value="Submit!" ref="submitButton" />
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
          <p className="post-description">{this.props.desc}</p>
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
    <LocationDisplay url={postsPath} pollInterval={500000} batchSize={10} breakpoint={775} />,
    document.body
  );
}
