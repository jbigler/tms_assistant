class AddIsCancelledToAssignment < ActiveRecord::Migration
  def self.up
    add_column :assignments, :is_cancelled, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :assignments, :is_cancelled
  end
end
