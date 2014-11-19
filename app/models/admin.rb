class Admin < ActiveRecord::Base
  has_secure_password
  validates :password, presence: true, on: :create
  has_many :administrations
  has_many :locations, through: :administrations
  
end
