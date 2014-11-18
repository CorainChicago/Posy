class LocationsController < ApplicationController

  def show
    url = params[:slug].downcase.strip
    @location = Location.find_by(slug: url)
    @post = Post.new
    redirect_to '/' unless @location
  end

  def admin

  end

end
