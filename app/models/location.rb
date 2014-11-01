class Location < ActiveRecord::Base
  has_many :posts

  validates :name, presence: true

  after_create { generate_slug }

    private

  def generate_slug
    self.slug ||= name.downcase.strip.gsub(/ /, '-')
    self.save
  end

  def to_param
    slug
  end

end
