class AddFlaggingsSessionIndex < ActiveRecord::Migration
  def change
    add_index :flaggings, :session_id
  end
end
