class AddComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :post_id
      t.text :content
      t.string :session_id
      t.string :author_name
      t.integer :flagged, default: 0

      t.timestamps
    end
  end
end
