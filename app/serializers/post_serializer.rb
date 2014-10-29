class PostSerializer < ActiveModel::Serializer
  attributes :id, :content, :gender, :hair_color, :spotted_at
end