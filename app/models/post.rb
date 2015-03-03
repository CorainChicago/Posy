class Post < ActiveRecord::Base
  include Content

  belongs_to :location
  has_many :comments
  has_many :flaggings, as: :flaggable

  validates :content, :location, presence: true

  def self.get_posts_by_location(args = {})
    flag_ids = Flagging.retreive_flagged_content(args[:session_id])
    post_flags = flag_ids[:posts]
    location_id = args[:location_id]
    batch_size = args[:batch_size]
    
    self.where(location_id: location_id)
        .where("status >= ?", 0)
        .where.not(id: post_flags)
        .order(id: :desc)
        .limit(batch_size)
        .includes(:comments)
  end

  def has_priority_comment?
    comments.each do |comment| 
      return true if comment.admin_priority?
    end
    false
  end

end
