class PostsController < ApplicationController
  respond_to :json
  before_action :get_location_by_slug, only: [:index, :create, :destroy, :clear]


  def index   

    args = {
      location_id: @location.id,
      offset: params[:offset],
      batch_size: params[:batch_size],
      session_id: session[:session_id]
    }

    render json: Post.get_posts_by_location(args)
  end

  def create
    new_post = Post.new(post_params)
    new_post.location = @location
    new_post.session_id = session[:session_id]

    if new_post.save
      render json: new_post
    else
      render json: {errors: new_post.errors.full_messages}, status: 400
    end
  end

  def destroy
    post = Post.find_by(id: params[:id])
    post.destroy_comments
    post.destroy

    redirect_to location_admin_path(@location)
  end

  def clear
    post = Post.find_by(id: params[:post_id])
    post.mark_as_cleared if post

    redirect_to location_admin_path(@location)
  end

  def flag
    post = Post.find_by(id: params[:post_id])
    flag = Flagging.create(flaggable: post, session_id: session[:session_id]) if post

    if flag
      render json: {}, status: 200
    else
      # this may need to be more specific or a different code
      render json: {}, status: 500
    end
  end

    private

  def post_params
    params.require(:post).permit(:hair, :gender, :spotted_at, :content)
  end

  def get_location_by_slug
    @location = Location.find_by(slug: params[:location_slug])
  end

end
