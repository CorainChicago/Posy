require 'rails_helper'

RSpec.describe Flagging, :type => :model do
  
  it { should belong_to :flaggable }

  describe 'after_create callback' do
    it 'should notify its flaggable to #update_flagged_count' do
      flaggable = build(:post)

      expect(flaggable).to receive(:update_flagged_count)
      create(:flagging, flaggable: flaggable)
    end
  end

  describe 'uniqueness validation' do
    it 'should not log multiple flaggings of same flaggable by single session' do
      flagging_one = create(:flagging, session_id: "0")
      flagging_two = build(:flagging, session_id: "0", flaggable: flagging_one.flaggable)
      
      expect(flagging_two.valid?).to be_falsey
    end
  end

  describe '.retreive_flagged_content' do
    # I strongly suspect I will change/remove this method shortly
    pending
  end
  
end
