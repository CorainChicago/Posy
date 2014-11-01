class Post < ActiveRecord::Base
  belongs_to :location
  has_many :comments
  has_many :flaggings, as: :flaggable

  validates :content, :location, presence: true

  def self.get_posts_by_location(args = {})
    flagged_threshold = 2

    # These may be too much hassle. Perhaps passing in order arguments would be ok here...
    offset = args[:offset]
    location_id = args[:location_id]
    batch_size = args[:batch_size]

    if offset
      return Post.where("location_id = ? AND (flagged < ? OR cleared = true)", location_id, flagged_threshold).limit(batch_size).offset(offset)
    else
      return Post.where("location_id = ? AND (flagged < ? OR cleared = true)", location_id, flagged_threshold).limit(batch_size)
    end

  end
end
