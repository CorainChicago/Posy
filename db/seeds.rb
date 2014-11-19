# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

hendrix = Location.create!(name: "Hendrix College", slug: "hendrix")

# 30.times do |i|
#   Post.create!(
#     location: hendrix,
#     session_id: 0,
#     gender: "female",
#     hair: "black",
#     spotted_at: "#{i}",
#     content: "#{i}"
#   )
# end

p1 = Post.create!(
  location: hendrix,
  content: "hey hey",
  session_id: "0",
  gender: "male",
  hair: "brown",
  spotted_at: "MC Reynolds"
)
p2 = Post.create!(
  location: hendrix,
  content: "yo yo",
  session_id: "0",
  gender: "male",
  hair: "black",
  spotted_at: "SLTC"
)
p3 = Post.create!(
  location: hendrix,
  content: "wassup wassup",
  session_id: "0",
  gender: "male",
  hair: "blonde",
  spotted_at: "Hardin Hall"
)

# #THIS SHOULD BE SHOWN BECAUSE IT IS CLEARED
# Post.create!(
#   location: hendrix,
#   content: "howdy",
#   session_id: "0",
#   gender: "male",
#   hair: "blonde",
#   spotted_at: "Hardin Hall",
#   flagged: 3,
#   cleared: true
# )

# # THIS SHOULD NOT BE SHOWN BECAUSE IT IS NOT CLEARED
# Post.create!(
#   location: hendrix,
#   content: "umph",
#   session_id: "0",
#   gender: "male",
#   hair: "blonde",
#   spotted_at: "Hardin Hall",
#   flagged: 3,
#   cleared: false
# )


# Comment.create!(
#   post: p1,
#   content: "yeah, you're probably right",
#   session_id: "1",
#   author_name: "Pine"
# )
# Comment.create!(
#   post: p1,
#   content: "nahhhhhh",
#   session_id: "2",
#   author_name: "Oak"
# )

[p1, p2, p3].each do |p|
  rand(3..6).times do |i|
    Comment.create!(
      post: p,
      content: Faker::Lorem.sentences( rand(1..3) ).join(" "),
      session_id: "#{p.to_s}#{i}",
    )
  end


end