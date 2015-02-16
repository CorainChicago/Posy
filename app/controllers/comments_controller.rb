class CommentsController < ApplicationController
  before_action :get_comment, except: [:create]

  def create
    post = Post.find_by(id: params[:post_id])
    session_id = session[:session_id]
    content = params[:comment]
    Comment.create(post: post, session_id: session_id, content: content)

    respond_to do |format|
      format.json { redirect_to_locations_posts }
    end
  end

  def destroy
    # For now, content is not destroyed, only hidden
    @comment.mark_as_removed
    redirect_to location_admin_path(params[:location_slug])
  end

  def flag
    # IMPLEMENT ME
  end

  def clear
    @comment.mark_as_cleared if @comment
    redirect_to location_admin_path(params[:location_slug])
  end



    private

  def get_comment
    id = params[:comment_id] || params[:id]
    @comment = Comment.find_by(id: id)
  end

  def redirect_to_locations_posts
    slug = params[:location_slug]
    size = params[:batchSize]
    redirect_to location_posts_path(location_slug: slug, batch_size: size)
  end

end