class AddPosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.string :session_id
      t.string :author_name
      t.string :gender
      t.string :hair_color
      t.string :location
      t.integer :flagged, default: 0

      t.timestamps
    end
  end
end
