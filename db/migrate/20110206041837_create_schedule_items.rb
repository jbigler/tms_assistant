class CreateScheduleItems < ActiveRecord::Migration
  def self.up
    create_table :schedule_items do |t|
      t.string  :title,             :limit   => 100
      t.string  :source,            :limit   => 50
      t.boolean :for_brother_only,  :default => false, :null => false
      t.boolean :for_adult_only,    :default => false, :null => false
      t.boolean :for_advanced_only, :default => false, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :schedule_items
  end
end
