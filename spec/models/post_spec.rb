require 'rails_helper'

RSpec.describe Post, :type => :model do
  it { should have_many :comments }
  it { should validate_presence_of :content }
  # it { should validate_presence_of :gender }
  # it { should validate_presence_of :hair }
  it { should validate_presence_of :location }
  it { should belong_to :location }
  it { should have_many :flaggings }

  describe '#get_posts_by_location' do
    before(:each) do
      tu = Location.create(name: "Testing University")
      30.times do |i|
        new_post = Post.create!(
          location: tu,
          content: Faker::Lorem.paragraph(3),
          session_id: 0,
          gender: ["", "Male", "Female"].sample,
          hair: ["Brown", "Blonde", "Red", "Black", ""].sample,
          spotted_at: "wherever"
        )

        if [0, 12, 22, 15].include? i
          new_post.update_attribute(:flagged, 99)
          new_post.update_attribute(:cleared, true) if i == 15
        end

      end
    end

    let(:args) do
      location_id = Location.find_by(name: "Testing University").id
      {location_id: location_id, batch_size: 10, offset: nil }
    end

    let(:uncleared_posts) { Post.where(flagged: 99, cleared: false) }
    let(:cleared_post) { Post.find_by(flagged: 99, cleared: true) }



    it 'should respond with the correct batch size (if available)' do
      posts = Post.get_posts_by_location(args)
      expect(posts.count).to be 10

      args[:batch_size] = 9
      posts = Post.get_posts_by_location(args)
      expect(posts.count).to be 9

      args[:batch_size] = 15
      posts = Post.get_posts_by_location(args)
      expect(posts.count).to be 15
    end

    it 'should return as many as available if fewer posts than batch_size' do
      args[:batch_size] = 100
      posts = Post.get_posts_by_location(args)
      expect(posts.count).to eq 27
    end

    it 'should not return posts that have been flagged above a threshold' do
      args[:batch_size] = 100
      posts = Post.get_posts_by_location(args)
      expect(posts.include? uncleared_posts[0]).to be false
      expect(posts.include? uncleared_posts[1]).to be false
      expect(posts.include? uncleared_posts[2]).to be false
    end

    it 'should retun posts that have been flagged but cleared' do
      args[:batch_size] = 100
      posts = Post.get_posts_by_location(args)
      expect(posts.include? cleared_post).to be true
    end


    it 'should return batches by offset' do
      first_batch_ids = Post.get_posts_by_location(args).pluck(:id)
      args[:offset] = first_batch_ids.count
      second_batch_ids = Post.get_posts_by_location(args).pluck(:id)
      args[:offset] = first_batch_ids.count + second_batch_ids.count
      third_batch_ids = Post.get_posts_by_location(args).pluck(:id)

      second_batch_ids.each do |id|
        expect(first_batch_ids.include? id).to be false
        expect(third_batch_ids.include? id).to be false
      end

      third_batch_ids.each do |id|
        expect(first_batch_ids.include? id).to be false
      end

      # Implicitly tests that offset does not include flagged/uncleared posts
      expect(first_batch_ids.uniq.count).to be 10
      expect(second_batch_ids.uniq.count).to be 10
      expect(third_batch_ids.uniq.count).to be 7
    end

  end

  describe "#updated_flagged_count" do
    before(:each) do
      Post.create!(
        location: Location.create(name: "Testing University"),
        content: "hello there",
        session_id: 0,
        gender: "Male",
        hair: "Brown",
        spotted_at: "wherever"
      )
    end

    let(:post) { Post.find_by(content: "hello there", spotted_at: "wherever") }
    
    it 'should update the flagged column of the record' do
      # This, perhaps unfortunately, is testing via a Flagging callback that calls this method
      expect{ Flagging.create(session_id: "0", flaggable: post) }.to \
        change{ Post.find_by(content: "hello there", spotted_at: "wherever").flagged }.by(1)
    end

  end
end
