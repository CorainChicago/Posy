class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :location

  validates :content, :gender, :location, :hair, presence: true
end
