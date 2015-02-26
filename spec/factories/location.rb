FactoryGirl.define do
  factory :location do

    name Faker::Address.city

    factory :location_with_posts do
      ignore do
        posts_count 5
      end

      after(:create) do |location, evaluator|
        create_list(:post, evaluator.posts_count, location: location)
      end
    end

  end
end