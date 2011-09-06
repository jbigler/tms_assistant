class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.date       :week_of,         :null    => false
      t.boolean    :has_review,      :default => false, :null => false
      t.references :language,        :null    => false
      t.references :bible_highlights
      t.references :talk_no1
      t.references :talk_no2
      t.references :talk_no3
      t.timestamps
    end

    add_index "schedules", ["language_id", "week_of"], :name => "index_schedules_language_and_week_of", :unique => true
  end

  def self.down
    drop_table :schedules
  end
end
