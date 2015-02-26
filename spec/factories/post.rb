FactoryGirl.define do
  factory :post do

    location

    content Faker::Lorem.sentence
    spotted_at Faker::Address.street_name

  end
end