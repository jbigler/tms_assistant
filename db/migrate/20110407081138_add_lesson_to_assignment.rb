class AddLessonToAssignment < ActiveRecord::Migration
  def self.up
    change_table :assignments do |t|
      t.references :lesson
      t.string :lesson_status
      t.integer :lesson_next
      t.text :lesson_notes
    end
  end

  def self.down
    change_table :assignments do |t|
      t.remove :lesson_id, :lesson_status, :lesson_next, :lesson_notes
    end
  end
end
