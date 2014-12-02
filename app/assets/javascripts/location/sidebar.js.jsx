/** @jsx React.DOM */

var Sidebar = React.createClass({
  handlePostSuccess: function() {
    this.hidePostForm();
  },  
  showPostForm: function() {
    $("#new-post-button").fadeOut('fast', function() {
      $("#post-form").fadeIn();
    });
    return false;
  },
  hidePostForm: function() {
    $("#post-form").fadeOut('fast', function() {
      $("#new-post-button").fadeIn();
    });
  },
  render: function() {
          // <h1 id="badge">POSY</h1>
          // <h2 id="location">{locationName}</h2>
    return(
      <div id="sidebar">
        <div id="sidebar-container">
          <img src={logoSVG} id="logo" />
          <button id="new-post-button" onClick={this.showPostForm}>Add Post</button>
          <PostForm ref="postForm" handlePostSubmit={this.props.handlePostSubmit} />
        </div>
        <a href="#" id="about-link">About</a>
      </div>
    )
  }
});
