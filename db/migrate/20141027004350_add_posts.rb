class AddPosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.string :session_id
      t.string :gender
      t.string :hair_color
      t.string :spotted_at
      t.integer :flagged, default: 0

      t.timestamps
    end
  end
end
