class AddSettingToAssignment < ActiveRecord::Migration
  def self.up
    add_column :assignments, :setting_id, :integer
  end

  def self.down
    remove_column :assignments, :setting_id
  end
end
