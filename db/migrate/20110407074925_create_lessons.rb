class CreateLessons < ActiveRecord::Migration
  def self.up
    create_table :lessons do |t|
      t.references :student,             :null => false
      t.references :lesson_source,       :null => false
      t.date       :date_started
      t.date       :date_completed
      t.boolean    :exercises_completed, :null => false, :default => false
      t.text       :notes

      t.timestamps
    end

    add_index :lessons, :student_id
  end

  def self.down
    drop_table :lessons
  end
end
