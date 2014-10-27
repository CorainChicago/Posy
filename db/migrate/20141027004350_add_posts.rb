class AddPosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.string :ip_address
      t.string :author_name
      t.string :gender
      t.string :hair_color
      t.string :location
      t.boolean :flagged

      t.timestamps
    end
  end
end
