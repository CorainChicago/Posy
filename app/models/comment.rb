class Comment < ActiveRecord::Base
  belongs_to :post
  has_many :flaggings, as: :flaggable


  validates :content, :post_id, presence: true
end
