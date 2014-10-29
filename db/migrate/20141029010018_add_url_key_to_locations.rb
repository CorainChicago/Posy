class AddUrlKeyToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :slug, :string
    add_index :locations, :slug
    remove_index :locations, :name
  end
end
