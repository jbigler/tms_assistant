class AddNextLessonToStudent < ActiveRecord::Migration
  def self.up
    add_column :students, :next_lesson, :integer
  end

  def self.down
    remove_column :students, :next_lesson
  end
end
