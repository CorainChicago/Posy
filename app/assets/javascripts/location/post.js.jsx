/** @jsx React.DOM */

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
          <CommentForm ref="newComment" 
                       postId={this.props.key} 
                       handleCommentSubmit={this.props.handleCommentSubmit} 
                       horizontal={this.props.horizontal} />
        </div>
        <p className="post-links">{this.props.age} ago |
        <a href="#" className="add-comment" onClick={this.showCommentForm}> Comment </a>|
        <a href="#" className="report-post" onClick={this.handleFlaggingClick}> Report </a></p>
      </div>
    );
  }
});