class PostSerializer < ActiveModel::Serializer
  attributes :id, :content, :gender, :hair, :spotted_at, :age

  has_many :comments
end