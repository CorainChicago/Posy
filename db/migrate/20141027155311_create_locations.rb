class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name

      t.timestamps
    end

    add_index :locations, :name

    add_column :posts, :location_id, :integer
  end
end
