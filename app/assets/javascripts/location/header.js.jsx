/** @jsx React.DOM */

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
        <p id="menu"> </p>
        <h1 id="badge">POSY</h1>
        <a href="#" id="new-post-link" onClick={this.togglePostForm} >+</a>
        <PostForm ref="postForm" handlePostSubmit={this.handlePostSubmit}/>
      </div>
    )
  }
})