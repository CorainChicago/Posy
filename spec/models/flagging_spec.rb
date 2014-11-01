require 'rails_helper'

RSpec.describe Flagging, :type => :model do
  it { should belong_to :flaggable }
end
