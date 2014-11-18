class Post < ActiveRecord::Base
  belongs_to :location
  has_many :comments
  has_many :flaggings, as: :flaggable

  validates :content, :location, presence: true

  @@flagged_threshold = 2

  def self.get_posts_by_location(args = {})
    # Originally implemented to retreive posts piecemeal through an offset;
    # that working code has been left in but commented out.

    offset = args[:offset]
    location_id = args[:location_id]
    batch_size = args[:batch_size]

    if offset
      posts = Post.where("location_id = ? AND (flagged < ? OR cleared = true)", location_id, @@flagged_threshold).order(id: :desc).limit(batch_size).offset(offset)
    else
      posts = Post.where("location_id = ? AND (flagged < ? OR cleared = true)", location_id, @@flagged_threshold).order(id: :desc).limit(batch_size)
    end

    filter_flaggings(posts, args[:session_id])
  end

  def update_flagged_count
    self.update_attribute(:flagged, self.flaggings.count)
  end

  def mark_as_cleared
    self.update_attribute(:cleared, true)
  end

  def destroy_comments
    self.comments.each { |c| c.destroy }
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
