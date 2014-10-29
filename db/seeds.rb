# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

hendrix = Location.create!(name: "Hendrix College", slug: "hendrix")

Post.create!(location: hendrix,
  content: "hey hey",
  session_id: "0",
  gender: "male",
  hair_color: "brown",
  spotted_at: "MC Reynolds"
)
Post.create!(
  location: hendrix,
  content: "yo yo",
  session_id: "0",
  gender: "male",
  hair_color: "black",
  spotted_at: "SLTC"
)
Post.create!(
  location: hendrix,
  content: "wassup wassup",
  session_id: "0",
  gender: "male",
  hair_color: "blonde",
  spotted_at: "Hardin Hall"
)