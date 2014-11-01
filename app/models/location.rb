class Location < ActiveRecord::Base
  has_many :posts

  validates :name, presence: true

  after_create { generate_slug }

  def get_posts(offset)
    Post.all
  end

    private

  def generate_slug
    self.slug ||= name.downcase.strip.gsub(/ /, '-')
    self.save
  end

  def to_param
    slug
  end

end
