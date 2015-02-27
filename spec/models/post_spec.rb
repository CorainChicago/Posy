require 'rails_helper'

RSpec.describe Post, :type => :model do
  it { should have_many :comments }
  it { should belong_to :location }
  it { should have_many :flaggings }
  it { should validate_presence_of :content }
  it { should validate_presence_of :location }

  it_behaves_like "Content"

  describe '#has_priority_comment?' do
    let(:post) { create(:post_with_comments) }

    it 'returns true if a related comment is an admin priority' do
      comment = create(:comment)
      allow(comment).to receive(:admin_priority?).and_return(true)
      post.comments << comment

      expect(post.has_priority_comment?).to be_truthy
    end

    it 'returns false if no related comments are admin priorities' do
      expect(post.has_priority_comment?).to be_falsey   
    end

    it 'returns false if there are no comments' do
      p = create(:post)
      expect(p.has_priority_comment?).to be_falsey
    end
  end

  describe '.get_posts_by_location' do

    let(:args) do
      location = create(:location_with_posts)
      { location_id: location.id }
    end

    def create_flagged_post(session_id)
      post = create(:post, location_id: args[:location_id])
      create(:flagging, flaggable: post, session_id: session_id)
      post
    end

    it 'returns a collection of posts' do
      posts = Post.get_posts_by_location(args)

      expect(posts.class).to match(Post::ActiveRecord_Relation)
    end

    it 'filters posts that have been removed/flagged excessively' do
      # This is a bit tightly coupled, but alas
      flagged = create(:post, location_id: args[:location_id], status: -1)
      posts = Post.get_posts_by_location(args)
      posts_count = Location.find(args[:location_id]).posts.count
      clear_count = posts.count

      expect(posts.include? flagged).to be_falsey
      expect(posts_count - clear_count).to eq 1
    end

    it 'filters posts that the given session has flagged' do
      args[:session_id] = "test"
      flagged = create_flagged_post(args[:session_id])
      posts = Post.get_posts_by_location(args)

      expect(posts.include? flagged).to be_falsey
    end

    it 'orders posts descendingly' do
      posts = Post.get_posts_by_location(args)
      desc = true
      (0...posts.count - 1).each do |i|
        if posts[i].created_at < posts[i + 1].created_at
          desc = false
          break
        end
      end

      expect(desc).to be_truthy
    end

    it 'limits the collection by batch size (if applicable)' do
      args[:batch_size] = 2000000
      posts_one = Post.get_posts_by_location(args)
      expect(posts_one.count).to eq Post.all.count

      args[:batch_size] = 2
      posts_two = Post.get_posts_by_location(args)
      expect(posts_two.count).to eq args[:batch_size]
    end

    it 'limits collection while accounting for filtered posts' do
      args[:batch_size] = 4
      args[:session_id] = "test'"
      flagged = create_flagged_post(args[:session_id])
      posts = Post.get_posts_by_location(args)

      expect(posts.count).to eq args[:batch_size]
      expect(posts.include? flagged).to be_falsey
    end

  end

end
