require 'rails_helper'

RSpec.describe Post, :type => :model do
  it { should have_many :comments }
  it { should validate_presence_of :content }
  it { should validate_presence_of :gender }
  it { should validate_presence_of :hair }
  it { should validate_presence_of :location }
  it { should belong_to :location }
end
