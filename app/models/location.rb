class Location < ActiveRecord::Base
  has_many :posts

  validates :name, presence: true

  after_create { generate_url_key }

  def generate_url_key
    url_key ||= name.downcase.strip.gsub(/ /, '_')
    save
  end

end
