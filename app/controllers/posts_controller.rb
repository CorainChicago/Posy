class PostsController < ApplicationController
  respond_to :json


  def index
    location = Location.select(:id).find_by(slug: params[:location_slug])
    
    args = {
      location_id: location.id,
      offset: params[:offset],
      batch_size: 10
    }

    respond_with Post.get_posts_by_location(args)
  end

  def create

  end

  def update

  end

  def delete

  end

end
