class AddCongregationsUsersJoinTable < ActiveRecord::Migration

  def self.up
    create_table :congregations_users, :id => false do |t|
      t.integer :congregation_id, :null => false
      t.integer :user_id,         :null => false
    end

    add_index :congregations_users, [:user_id, :congregation_id], :name => "index_congregations_users_on_user_and_congregation"
    add_index :congregations_users, [:congregation_id, :user_id], :name => "index_congregations_users_on_congregation_and_user"
  end

  def self.down
    drop_table :congregations_users
  end

end
