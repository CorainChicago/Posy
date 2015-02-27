require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { should belong_to :post }
  it { should have_db_index :post_id }
  it { should have_many :flaggings }
  it { should validate_presence_of :content }
  it { should validate_presence_of :post_id }

  it_behaves_like "Content"

  describe '#generate_author_name' do
    it 'is called upon creation of comment' do
      comment = build(:comment)

      expect(comment).to receive(:generate_author_name).once
      comment.save
    end

    it 'assigns the name "author" if created in same session as associated-post' do
      session = "test"
      post = create(:post, session_id: session)
      comment = create(:comment, post: post, session_id: session)

      expect(comment.author_name.capitalize).to eq "Author"
    end

    it 'assigns the same name if a previous comment has been made by same session' do
      session = "test"
      post = create(:post, session_id: session)
      comment_one = create(:comment, post: post, session_id: session)
      comment_two = create(:comment, post: post, session_id: session)

      expect(comment_one.author_name).to eq comment_two.author_name
    end

    it 'creates unique names for each comment by different session' do
      post = create(:post_with_comments, comments_count: 35)
      names = post.comments.pluck(:author_name)
      uniq  = names.uniq

      expect(names.count).to eq (uniq.count)
    end

  end

end