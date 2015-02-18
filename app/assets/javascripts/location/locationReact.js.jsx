/** @jsx React.DOM */

var LocationPosts = React.createClass({
  getInitialState: function() {
    return { posts: [] };
  },

  componentDidMount: function() {
    this.loadPostsFromServer(this.props.batchSize);
    setInterval(this.loadPostsFromServer, this.props.pollInterval);
    var that = this;

    // register listeners
    $(window).on('scroll', this.handleScroll);
    $("#location-posts").on('submit', ".new-comment", function(e) {
      e.preventDefault();
      that.handleCommentSubmit(this);
    });
    $("#new-post-form").on('submit', function(e) {
      e.preventDefault();
      that.handlePostSubmit(this);
    });
  },

  loadPostsFromServer: function(numPosts) {
    var size = numPosts || this.state.posts.length;
    var that = this;

    $.ajax({
      url: that.props.path,
      data: { batch_size: size },
      dataType: 'json',
    })
    .done(function(response) {
      var posts = response.posts;
      if (posts.length < size) {
        // oldest post retreived, stop handling scroll
        $(window).off('scroll');
        $("#location-complete").show();
      }
      that.setState({posts: posts});
    })
    .fail(function(response) {
      // IMPLEMENT ERROR MESSAGE
    });
  },

  handleScroll: function() {
    // REFACTOR?
    if ( parseInt($(window).scrollTop()) == parseInt($(document).height() - $(window).height())) {
      var newSize = this.state.posts.length + this.props.batchSize;
      this.loadPostsFromServer(newSize);
    }
  },

  handlePostSubmit: function(form) {
    var data = getNewPostInput(form);
    if (data) {
      disableForm(form);
      var path = $(form).attr('action');
      var that = this;

      $.ajax({
        url: path,
        method: "POST",
        data: data
      })
      .done(function(response) {
        that.setState({ posts: response.posts });
        resetForm(form);
        togglePostForm();
      })
      .error(function(response) {
        // IMPLEMENT ERROR MESSAGE
      })
      .always(function() {
        enableForm(form);
      });
    }
  },

  // REFACTOR?
  handleCommentSubmit: function(form) {
    var that = this;
    var $form = $(form);
    var $input = $form.find('input[type=text]');
    var text = getText($input);

    if (text) {
      disableForm(form);
      var path = $form.attr('action');
      $.ajax({
        method: "POST",
        url: path,
        data: {
          comment: text
        }
      })
      .done(function(response) {
        that.setState({ posts: response.posts });
        $form.hide(250);
        $input.val('');
      })
      .always(function() {
        enableForm(form);
      });
    }
  },

  render: function() {
    var that = this;
    var postNodes = this.state.posts.map(function(post) {
      return (
        <Post 
        location={post.spotted_at}
        description={post.description}
        content={post.content}
        comments={post.comments}
        age={post.age}
        key={post.id} />
      )
    })

    return (
      <div id="react-location-posts-container">
        { postNodes }
      </div>
    );
  }
});

var Post = React.createClass({
  handleCommentClick: function(e) {
    e.preventDefault();
    this.refs.list.showCommentForm();
  },

  handleFlaggingClick: function(e) {
    e.preventDefault();
    var path = window.location.pathname + "/posts/" + this.props.key + "/flag";
    var that = this;

    $.post(path, function(response) {
      $(that.getDOMNode()).hide(250);
    });
  },

  render: function() {
    return (
      <div className="post" ref="postContainer">
        <h4 className="post-location">at { this.props.location }</h4>
        <h5 className="post-description">{ this.props.description }</h5>
        <p className="post-content">{ this.props.content }</p>
      
        <CommentList comments={this.props.comments} postId={this.props.key} ref="list" />
        <p className="post-links">
          {this.props.age} ago | 
          <a className="post-links-comment" href="#" onClick={this.handleCommentClick} >Comment</a> | 
          <a className="post-links-report" href="#" onClick={this.handleFlaggingClick} >Report</a>
        </p>
      </div>
    )
  }
});

var CommentList = React.createClass({
  showCommentForm: function() {
    var form = this.refs.form.getDOMNode();
    if ( $(form).is(':visible') ) {
      $('.new-comment:visible').hide(250);
    }
    else {
      $('.new-comment:visible').hide(250);
      $(form).show(250);
    }
  },

  render: function() {
    var commentNodes = this.props.comments.map(function(comment) {
      return <Comment
        author={comment.author_name}
        content={comment.content}
        key={comment.id} />
    })

    return(
      <div className="comment-container">
        <div className="comment-list">
          { commentNodes }
          <CommentForm postId={this.props.postId} ref="form" />
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

var CommentForm = React.createClass({
  postPath: function() {
    return window.location.pathname + "/posts/" + this.props.postId + "/comments";
  },

  render: function() {
    return (
      <form className="new-comment" action={ this.postPath() } method="POST">
        <input type="text"></input>
        <button type="submit">
          <i className="fa fa-check"></i>
        </button>
      </form>
    )
  }
})