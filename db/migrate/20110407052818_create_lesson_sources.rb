class CreateLessonSources < ActiveRecord::Migration
  def self.up
    create_table :lesson_sources do |t|
      t.references :language
      t.integer    :chapter,               :null => false
      t.string     :description,           :null => false, :limit   => 150,  :default => ""
      t.integer    :page_number
      t.boolean    :use_for_reading,       :null => false, :default => false
      t.boolean    :use_for_demonstration, :null => false, :default => false
      t.boolean    :use_for_discourse,     :null => false, :default => false
      t.text       :notes

      t.timestamps
    end

    add_index :lesson_sources, [:language_id, :chapter]
  end

  def self.down
    drop_table :lesson_sources
  end
end
