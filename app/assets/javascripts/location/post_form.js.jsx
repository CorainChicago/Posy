/** @jsx React.DOM */

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
  hideForm: function() {
    this.props.cancel();
    return false; // disables blank anchor tag on 'cancel' link
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
              <option value="Female">Female</option>
              <option value="Other">Other</option>
            </select>
          </div>
        </div>

        <div className="post-form-select">
          <label for="post_hair" id="post_hair_label" >Hair</label><br/>
          <div className="post-form-select-background">
            <select id="post_hair" name="post[hair]" >
              <option value=""></option>
              <option value="Brown">Brown</option>
              <option value="Black">Black</option>
              <option value="Blonde">Blonde</option>
              <option value="Red">Red</option>
              <option value="Other">Other</option>
            </select>
          </div>
        </div>

        <label for="post_spotted_at">Location <span id="location-requirement">(required)</span></label>
        <input id="post_spotted_at" name="post[spotted_at]" type="text" /><br/>

        <label for="post_content">Message <span id="content-requirement">(required)</span></label>
        <textarea id="post_content" name="post[content]" rows="4" ref="contentField"></textarea><br/>

        <input type="submit" value="Submit!" ref="submitButton" />
        <a id="post-form-cancel" href="#" onClick={this.props.cancel}>Cancel</a>
      </form>
    )
  }
})