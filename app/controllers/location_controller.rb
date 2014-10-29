class LocationController < ApplicationController

  def show
    url = params[:location_name].downcase.strip
    @location = Location.find_by(slug: url)
    redirect_to '/' unless @location
  end

end