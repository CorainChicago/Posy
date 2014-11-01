class CreateFlaggings < ActiveRecord::Migration
  def change
    create_table :flaggings do |t|
      t.string :session_id
      t.string :flaggable_type
      t.integer :flaggable_id

      t.timestamps
    end

    add_index :flaggings, [:flaggable_id, :flaggable_type]
  end
end
