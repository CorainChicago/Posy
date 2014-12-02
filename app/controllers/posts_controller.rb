class PostsController < ApplicationController
  respond_to :json
  before_action :get_location_by_slug, only: [:index, :create]
  before_action :get_post, only: [:destroy, :clear, :flag]

  def index   
    args = {
      location_id: @location.id,
      # offset: params[:offset],
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
      index
    else
      render json: {errors: new_post.errors.full_messages}, status: 400
    end
  end

  def destroy
    # For now, content is not deleted, only hidden
    @post.mark_as_removed

    redirect_to location_admin_path(params[:location_slug])
  end

  def clear
    @post.mark_as_cleared if @post
    redirect_to location_admin_path(params[:location_slug])
  end

  def flag
    flag = Flagging.create(flaggable: @post, session_id: session[:session_id]) if @post

    if flag
      render json: {}, status: 200
    else
      # this may need to be more specific or a different code
      render json: {}, status: 500
    end
  end

    private

  def post_params
    process_breaks
    params[:post][:hair].downcase! if params[:post][:hair]
    params[:post][:gender].downcase! if params[:post][:gender]
    params[:post][:spotted_at].strip! if params[:post][:spotted_at]
    params.require(:post).permit(:hair, :gender, :spotted_at, :content)
  end

  def process_breaks
    if params[:post][:content]
      params[:post][:content].gsub!(/[\n(\r\n)(\n\r)]+/, "\n")
      params[:post][:content].squeeze!("\n")
      params[:post][:content].strip!
    end
  end

  def get_location_by_slug
    @location = Location.find_by(slug: params[:location_slug])
  end

  def get_post
    id = params[:post_id] || params[:id]
    @post = Post.find_by(id: id)
  end

end
