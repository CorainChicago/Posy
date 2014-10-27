class Post < ActiveRecord::Base
  has_many :comments

  validates :content, :gender, :location, :hair_color, presence: true
end
