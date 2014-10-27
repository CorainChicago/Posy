class AddDefaultToFlagged < ActiveRecord::Migration
  def change
    change_column :posts, :flagged, :boolean, default: false
    change_column :comments, :flagged, :boolean, default: false
  end
end
