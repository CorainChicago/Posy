class ChangeClearedToStatus < ActiveRecord::Migration
  def change
    remove_column :posts, :cleared
    remove_column :comments, :cleared

    add_column :posts, :status, :integer, default: 0
    add_column :comments, :status, :integer, default: 0
  end
end
