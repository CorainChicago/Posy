class LocationsController < ApplicationController
  before_action :get_location

  def show

    # raise params.inspect
    # url = params[:slug].downcase.strip
    # @location = Location.find_by(slug: url)
    # # @post = Post.new
    # redirect_to '/' unless @location
  end

    private

  def get_location
    url = params[:slug].downcase.strip
    @location = Location.find_by(slug: url)
    redirect_to '/' unless @location
  end

end
