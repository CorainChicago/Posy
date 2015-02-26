class Admin < ActiveRecord::Base
  has_secure_password
  has_many :administrations
  has_many :locations, through: :administrations
  
  validates :password, presence: true, on: :create
end
