require 'rails_helper'

RSpec.describe Flagging, :type => :model do

  before(:each) do
    new_post = Post.create!(
      location: Location.create(name: "Testing University"),
      content: "hello there",
      session_id: 0,
      gender: "Male",
      hair: "Brown",
      spotted_at: "wherever"
    )
    Comment.create(
      author_name: "Oak",
      session_id: "0",
      content: "hey-o",
      post: new_post
    )
  end

  let(:post) { Post.find_by(content: "hello there", spotted_at: "wherever") }
  let(:comment) { Comment.find_by(content: "hey-o", author_name: "Oak") }
  
  it { should belong_to :flaggable }

  describe 'after_create callback' do

    it 'should update flagged count of flaggable' do
      expect(post).to receive(:update_flagged_count)
      Flagging.create(session_id: "0", flaggable: post)

      expect(comment).to receive(:update_flagged_count)
      Flagging.create(session_id: "0", flaggable: comment)
    end

  end

  describe "uniqueness validation" do
    it 'should not log multiple flaggings of same flaggable in a single session' do
      Flagging.create(session_id: "0", flaggable: post)
      second_flagging = Flagging.new(session_id: "0", flaggable: post)
      expect(second_flagging.valid?).to be false
    end
  end
  
end
