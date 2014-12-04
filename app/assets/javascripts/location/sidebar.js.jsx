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
          <div id="sidebar-logo">
            <h1 id="logo-type">Posy</h1>
            <h3 id="logo-desc">Compliments for those around you</h3>
          </div>
          <div id="sidebar-non-logo">
            <h2 id="listLocation" className="hide-on-big">{locationName}</h2>
            <button id="new-post-button" onClick={this.showPostForm}>Add Post</button>
            <PostForm ref="postForm" handlePostSubmit={this.props.handlePostSubmit} cancel={this.hidePostForm} />
            <a href="#" id="about-link" >About</a>
          </div>
        </div>
      </div>
    )
  }
});
