class CreateFlaggings < ActiveRecord::Migration
  def change
    create_table :flaggings do |t|
      t.string :session_id
      t.integer :flaggable_id

      t.timestamps
    end
  end
end
