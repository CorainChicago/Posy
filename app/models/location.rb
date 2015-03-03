class Location < ActiveRecord::Base
  has_many :posts
  has_many :administrations
  has_many :admins, through: :administrations

  validates :name, presence: true

  after_create { generate_slug }

  def to_param
    slug
  end

    private

  def generate_slug
    self.slug ||= name.downcase.strip.gsub(/ /, '-')
    save
  end

end
