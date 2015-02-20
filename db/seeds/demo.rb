demo_location = Location.find_by(slug:"demo") || Location.create(
  slug: "demo", name: 'Demo Location', description: "Demo City, UT")

rand(33..38).times do |n|
  post = Post.new
  post.location = demo_location
  post.spotted_at = Faker::Address.street_name
  post.hair = ['Red', 'Brown', 'Black', 'Brown', ''].sample
  post.gender = ['Male', 'Female', ''].sample
  post.content = Faker::Lorem.sentences(rand(1..4)).join(" ")
  post.session_id = rand(0..5).to_s
  post.save

  rand(0..5).times do |m|
    comment = Comment.new
    comment.post = post
    comment.content = Faker::Lorem.sentences(rand(1..3)).join(" ")
    comment.session_id = rand(0..5).to_s
    comment.save
  end

end