class LocationsController < ApplicationController
  before_action :get_location

  def show

    # raise params.inspect
    # url = params[:slug].downcase.strip
    # @location = Location.find_by(slug: url)
    # # @post = Post.new
    # redirect_to '/' unless @location
  end

  def admin
    admin_ids = @location.admins.pluck(:id)
    if admin_ids.include? current_admin_id
      @posts = @location.posts.order(:created_at => :desc)
      @priorities = @posts.select do |post| 
        post.admin_priority? || post.has_priority_comment?
      end
    else
      redirect_to login_path
    end
  end

    private

  def get_location
    url = params[:slug].downcase.strip
    @location = Location.find_by(slug: url)
    redirect_to '/' unless @location
  end

end
