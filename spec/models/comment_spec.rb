require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { should belong_to :post }
  it { should validate_presence_of :content }
  it { should validate_presence_of :post_id }
  it { should have_db_index :post_id }
  it { should have_many :flaggings }

  before(:each) do
    new_post = Post.create!(
      location: Location.create(name: "Testing University"),
      content: "hello there",
      session_id: "abc",
      gender: "Male",
      hair: "Brown",
      spotted_at: "wherever"
    )
    Comment.create(
      session_id: "0",
      content: "hey-o",
      post: new_post
    )
  end

  describe '#update_flagged_count' do

    let(:comment) { Comment.find_by(content: "hey-o")}

    it 'should update the flagged column of the record' do
      # This, perhaps unfortunately, is testing via a Flagging callback that calls this method
      expect{ Flagging.create(session_id: "0", flaggable: comment) }.to \
        change{ Comment.find_by(content: "hey-o").flagged }.by(1)
    end

  end

  describe '#generate_author_name' do
    # this is a callback method and will not be called directly here

    let(:post) { Post.find_by(content: "hello there") }

    it 'should be called when a comment is first created' do
      first_comment = Comment.new(post: post, session_id: "0", content: "test")

      expect(first_comment).to receive(:generate_author_name)
      first_comment.save
    end

    it 'should create unique names for unique session_ids' do
      num_comments = 30
      authors = []

      num_comments.times do |i|
        c = Comment.create(post: post, session_id: i.to_s, content: "test")
        authors << c.author_name
      end

      expect(authors.compact.uniq.count).to eq num_comments
    end

    it 'should assign the same name for each comment from a single session' do
      authors = []

      3.times do
        c = Comment.create(post: post, session_id: "0", content: "test")
        authors << c.author_name
      end

      expect(authors.compact.uniq.count).to eq 1
    end

    it 'should assign the name "author" to comment from same session as post' do
      comment = Comment.create(post: post, session_id: post.session_id, content: "test")
      expect(comment.author_name).to eq "Author"
    end

  end

end