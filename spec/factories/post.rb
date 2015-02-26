FactoryGirl.define do
  factory :post do

    location

    content Faker::Lorem.sentence
    spotted_at Faker::Address.street_name

    factory :post_with_comments do
      ignore do
        comments_count 3
      end

      after(:create) do |post, evaluator|
        create_list(:comment, evaluator.comments_count, post: post)
      end
    end

  end
end