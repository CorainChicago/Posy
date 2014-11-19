class CreateAdminLocationJoinTable < ActiveRecord::Migration
  def change
    create_table :administrations do |t|
      t.integer :admin_id
      t.integer :location_id

      t.timestamps
    end
  end
end
