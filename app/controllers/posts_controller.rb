class PostsController < ApplicationController
  respond_to :json


  def index
    location = Location.find_by(slug: params[:location_slug])
    offset = params[:offset]
    batch_size = 10
    # respond_with Post.where("location_id = ? AND (flagged < ? OR cleared = true)", location.id, 2)
    respond_with location.get_posts(offset, batch_size)
  end

  def create

  end

  def update

  end

  def delete

  end

end
