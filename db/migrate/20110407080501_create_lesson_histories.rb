class CreateLessonHistories < ActiveRecord::Migration
  def self.up
    create_table :lesson_histories do |t|
      t.references :lesson,          :null => false
      t.date       :assignment_date, :null => false
      t.text       :notes

      t.timestamps
    end

    add_index :lesson_histories, :lesson_id
  end

  def self.down
    drop_table :lesson_histories
  end
end
