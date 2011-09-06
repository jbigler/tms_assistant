class RemoveCancan < ActiveRecord::Migration
  def up
    drop_table :roles
    drop_table :roles_users

    add_column :users, :admin, :boolean, :default => false
  end

  def down
    create_table "roles", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "roles_users", :id => false, :force => true do |t|
      t.integer "role_id"
      t.integer "user_id"
    end

    remove_column :users, :admin
  end
end
