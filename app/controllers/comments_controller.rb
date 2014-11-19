class CommentsController < ApplicationController
  before_action :get_comment, except: [:create]

  def create
    # IMPLEMENT ME
  end

  def destroy
    # For now, content is not destroyed, only hidden
    # @comment.destroy
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

end