class PostsController < ApplicationController
  respond_to :json


  def index
    location = Location.find_by(slug: params[:location_slug])
    respond_with Post.where("location_id = ? AND (flagged < ? OR cleared = true)", location.id, 2)
  end

  def create

  end

  def update

  end

  def delete

  end

end
