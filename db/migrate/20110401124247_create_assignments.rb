class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.references :student
      t.references :assistant
      t.references :substitute
      t.references :schedule_item
      t.date       :week_of,      :null  => false
      t.string     :type,         :limit => 20
      t.string     :state,        :limit => 20
      t.string     :completed_by
      t.text       :notes
      t.timestamps
    end

    add_index :assignments, :student_id
    add_index :assignments, :assistant_id
  end

  def self.down
    drop_table :assignments
  end
end
