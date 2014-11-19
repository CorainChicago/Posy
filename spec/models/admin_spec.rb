require 'rails_helper'

RSpec.describe Admin, :type => :model do
  it { should have_many :administrations }
  it { should have_many :locations }
end
