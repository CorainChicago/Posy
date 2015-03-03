FactoryGirl.define do
  factory :flagging do

    association :flaggable, factory: :post



    factory :flagging_for_comment do

      association :flaggable, factory: :comment

    end

  end
end