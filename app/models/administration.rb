class Administration < ActiveRecord::Base
  belongs_to :admin
  belongs_to :location
end