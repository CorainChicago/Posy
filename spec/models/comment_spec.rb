require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { should belong_to :post }
  it { should validate_presence_of :content }
  it { should validate_presence_of :post_id }
  it { should have_db_index :post_id }
  it { should have_many :flaggings }

  describe '#update_flagged_count' do
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

    let(:comment) { Comment.find_by(content: "hey-o", session_id: "0")}

    it 'should update the flagged column of the record' do
      # This, perhaps unfortunately, is testing via a Flagging callback that calls this method
      expect{ Flagging.create(session_id: "0", flaggable: comment) }.to \
        change{ Comment.find_by(content: "hey-o", session_id: "0").flagged }.by(1)
    end


  end
end
