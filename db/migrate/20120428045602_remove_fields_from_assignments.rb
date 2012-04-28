class RemoveFieldsFromAssignments < ActiveRecord::Migration
  def up
    remove_column :assignments, :is_cancelled
    remove_column :assignments, :completed_by
  end

  def down
    add_column :assignments, :is_cancelled, :boolean
    add_column :assignments, :completed_by, :string
  end
end
