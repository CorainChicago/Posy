class Post < ActiveRecord::Base
  include Content

  belongs_to :location
  has_many :comments
  has_many :flaggings, as: :flaggable

  validates :content, :location, presence: true

  def self.get_posts_by_location(args = {})
    location_id = args[:location_id]
    batch_size = args[:batch_size]
    posts = Post.where("location_id = ? AND status >= 0", location_id).order(id: :desc).limit(batch_size).includes(:comments)

    posts = filter_flaggings(posts, args[:session_id])
  end

  def has_priority_comment?
    priority = false
    self.comments.each { |comment| priority = true if comment.admin_priority? }
    priority
  end

    private

  def self.filter_flaggings(posts, session_id)
    flagging_ids = Flagging.retreive_flagged_content(session_id)

    posts = posts.reject{ |post| flagging_ids[:posts].include? post.id }

    posts.each_with_index do |post, i|
      # could possibly be made more efficient (runs some series of transactions)
      posts[i].comments = post.comments.reject do |comment| 
        flagging_ids[:comments].include? comment.id
      end    
    end

    posts
  end


end
