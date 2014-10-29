class Location < ActiveRecord::Base
  has_many :posts

  validates :name, presence: true

  after_create { generate_slug }

  def generate_slug
    slug ||= name.downcase.strip.gsub(/ /, '_')
    save
  end

  def to_param
    slug
  end

end
