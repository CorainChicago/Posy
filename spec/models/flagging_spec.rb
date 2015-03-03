require 'rails_helper'

RSpec.describe Flagging, :type => :model do
  
  it { should belong_to :flaggable }

  describe 'after_create callback' do
    it 'notifies its flaggable to #update_flagged_count' do
      flaggable = build(:post)

      expect(flaggable).to receive(:update_flagged_count)
      create(:flagging, flaggable: flaggable)
    end
  end

  describe 'uniqueness validation' do
    it 'does not log multiple flaggings of same flaggable by single session' do
      flagging_one = create(:flagging, session_id: "0")
      flagging_two = build(:flagging, session_id: "0", flaggable: flagging_one.flaggable)
      
      expect(flagging_two.valid?).to be_falsey
    end
  end

  describe 'class methods to retrieve flagged content' do
    let(:session) { "test_session" }

    before(:context) do
      create(:flagging, session_id: "foo")
      create(:flagging_for_comment, session_id: "test")
    end

    let(:flagged_post) { create(:flagging, session_id: session) }
    let(:flagged_comment) { create(:flagging_for_comment, session_id: session) }

    describe '.flagged_by_session' do
      it 'returns flagged content for a given session_id' do
        flagged = Flagging.flagged_by_session(session)

        expect(flagged).to match_array([flagged_post, flagged_comment])
      end
    end

    describe '.posts_flagged_by_session' do

      it 'returns flagged posts for a given session_id' do
        flagged = Flagging.posts_flagged_by_session(session)

        expect(flagged).to match_array([flagged_post])
      end
    end

    describe '.comments_flagged_by_session' do
      it 'returns flagged comments for a given session_id' do
        flagged = Flagging.comments_flagged_by_session(session)

        expect(flagged).to match_array([flagged_comment])
      end
    end
  end
  
end
