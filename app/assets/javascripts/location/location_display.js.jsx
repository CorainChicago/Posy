/** @jsx React.DOM */

var LocationDisplay = React.createClass({
  getInitialState: function() {
    var horizontal = window.innerWidth > this.props.breakpoint;

    return {
      posts: [],
      horizontal: horizontal
    };
  },

  componentDidMount: function() {
    this.loadPostsFromServer(this.props.batchSize);
    setInterval(this.loadPostsFromServer, this.props.pollInterval);

    $(window).on('resize', this.handleResize);
    $(window).on('scroll', this.handleScroll);
  },

  loadPostsFromServer: function(numPosts) {
    var size = numPosts || this.state.posts.length
    var that = this;

    $.ajax({
      url: this.props.url,
      data: { batch_size: size },
      dataType: 'json'
    })
    .done(function(response) {
      var posts = response.posts;
      if (posts.length < size) {
        $(window).off('scroll'); // oldest post retreived, stop handling scroll
        $("#exhausted-circle").css("display", "block");
      }
      that.setState({posts: posts})
    })
    .fail(function(response) {
      // IMPLEMENT ERROR MESSAGE?
    })
  },

  handleResize: function() {
    var horizontal = window.innerWidth > this.props.breakpoint;
    if (!horizontal && this.state.horizontal) {
      this.setState({ horizontal: false });
    }
    else if (horizontal && !this.state.horizontal) {
      this.setState({ horizontal: true });
    }
  },

  handleScroll: function() {
    // refactor line below
    if ( parseInt($(window).scrollTop()) == parseInt($(document).height() - $(window).height())) {
      newSize = this.state.posts.length + this.props.batchSize;
      this.loadPostsFromServer(newSize);
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
        else {
          that.refs.sidebar.hidePostForm();
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

  render: function() {  
      return (
        <div id="location-container">
          <Sidebar ref="sidebar" handlePostSubmit={this.handlePostSubmit} horizontal={this.state.horizontal}/>
          <div id="location-posts">
              <PostList handleFlagging={this.handleFlagging} 
                        handleCommentSubmit={this.handleCommentSubmit} 
                        posts={this.state.posts} 
                        horizontal={this.state.horizontal} />
          </div>
        </div>
      )
  }
});