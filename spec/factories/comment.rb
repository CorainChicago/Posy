FactoryGirl.define do
  factory :comment do

    post

    content Faker::Lorem.sentence


  end
end