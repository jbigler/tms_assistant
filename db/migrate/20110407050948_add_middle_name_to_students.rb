class AddMiddleNameToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :middle_name, :string, :limit => 50
  end

  def self.down
    remove_column :students, :middle_name
  end
end
