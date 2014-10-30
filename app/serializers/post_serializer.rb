class PostSerializer < ActiveModel::Serializer
  attributes :id, :content, :gender, :hair, :spotted_at

  has_many :comments
end