class AddUrlKeyToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :url_key, :string
    add_index :locations, :url_key
    remove_index :locations, :name
  end
end
