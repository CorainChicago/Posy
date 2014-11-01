class Comment < ActiveRecord::Base
  belongs_to :post
  has_many :flaggings, as: :flaggable


  validates :content, :post_id, presence: true

  def update_flagged_count
    self.update_attribute(:flagged, self.flaggings.count)
  end

end
