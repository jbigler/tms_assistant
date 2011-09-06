class AddDefaultCongregationToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :default_congregation_id, :integer
  end

  def self.down
    remove_column :users, :default_congregation_id
  end
end
