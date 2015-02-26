FactoryGirl.define do
  factory :flagging do

    association :flaggable, factory: :post

  end
end