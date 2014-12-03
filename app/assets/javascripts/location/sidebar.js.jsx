/** @jsx React.DOM */

var Sidebar = React.createClass({
  handlePostSuccess: function() {
    this.hidePostForm();
  },  
  showPostForm: function() {
    var that = this;
    $("#new-post-button").fadeOut('fast', function() {
      if (!that.props.horizontal) {
        $("#sidebar").css("height", "auto");
      }
      $("#post-form").fadeIn();
    });
    return false;
  },
  hidePostForm: function() {
    var that = this;
    $("#post-form").fadeOut('fast', function() {
      if (!that.props.horizontal) {
        $("#sidebar").css("height", "100vh");
      }
      $("#new-post-button").fadeIn();
    });
  },
  render: function() {
    return(
      <div id="sidebar">
        <div id="sidebar-container">
          <img src={logoSVG} onerror={"this.src=" + logoFallback + ""} id="logo" />
          <h2 id="listLocation" className="hide-on-big">{locationName}</h2>
          <button id="new-post-button" onClick={this.showPostForm}>Add Post</button>
          <PostForm ref="postForm" handlePostSubmit={this.props.handlePostSubmit} />
        </div>
        <a href="#" id="about-link" className="hide-on-small">About</a>
      </div>
    )
  }
});
