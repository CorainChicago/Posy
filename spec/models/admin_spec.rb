require 'rails_helper'

RSpec.describe Admin, :type => :model do
  it { should have_many :administrations }
  it { should have_many :locations }
  it { should validate_presence_of :password }
end
