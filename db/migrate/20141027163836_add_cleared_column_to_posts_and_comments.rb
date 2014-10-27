class AddClearedColumnToPostsAndComments < ActiveRecord::Migration
  def change
    add_column :posts, :cleared, :boolean, default: false
    add_column :comments, :cleared, :boolean, default: false
  end
end
