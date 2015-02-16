class CommentSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :content, :author_name

end