class Post < ActiveRecord::Base
  include Content

  belongs_to :location
  has_many :comments
  has_many :flaggings, as: :flaggable

  validates :content, :location, presence: true

  attr_accessor :age

  @@flagged_threshold = 2

  def self.get_posts_by_location(args = {})
    # Originally implemented to retreive posts piecemeal through an offset.
    # For now, that offset is never present

    offset = args[:offset]
    location_id = args[:location_id]
    batch_size = args[:batch_size]

    if offset
      posts = Post.where("location_id = ? AND status >= 0", location_id).order(id: :desc).limit(batch_size).offset(offset).includes(:comments)
    else
      posts = Post.where("location_id = ? AND status >= 0", location_id).order(id: :desc).limit(batch_size).includes(:comments)
    end

    @@time = Time.now
    posts.each { |post| post.add_age }
    posts = filter_flaggings(posts, args[:session_id])

  end

  # def destroy_comments
  #   self.comments.each { |c| c.destroy }
  # end

  def has_priority_comment?
    self.comments.each { |comment| return true if comment.admin_priority? }
    return false
  end

  def add_age
    minute = 60; hour = 60 * 60; day = hour * 24

    seconds = (@@time - self.created_at).to_i

    if (days = seconds / day) > 0
      self.age = "#{days} days"
    elsif (hours = seconds / hour) > 0
      self.age = "#{hours} hours"
    elsif (minutes = seconds / minute) > 0
      self.age = "#{minutes} minutes"
    else
      self.age = "#{seconds} seconds"
    end
  end

    private

  def self.filter_flaggings(posts, session_id)
    flagging_ids = Flagging.retreive_flagged_content(session_id)

    posts = posts.reject{ |post| flagging_ids[:posts].include? post.id }

    posts.each_with_index do |post, i|
      posts[i].comments = post.comments.reject do |comment| 
        flagging_ids[:comments].include? comment.id
      end    
    end

    posts
  end


end
