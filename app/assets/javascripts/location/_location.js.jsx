/** @jsx React.DOM */

/* REACT STRUCTURE 
  -LocationDisplay
    (if width > ~750px)
      -Sidebar
        -PostForm
    (if width < ~750px)
      -Header
        -PostForm
    -PostList
      -Post
        -CommentForm
        -CommentList
          -Comment
*/

var reactLocationReady = function() {
  React.renderComponent(
    <LocationDisplay url={postsPath} pollInterval={10000} batchSize={10} breakpoint={775} />,
    document.body
  );
}