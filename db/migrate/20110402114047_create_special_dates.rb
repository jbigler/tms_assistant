class CreateSpecialDates < ActiveRecord::Migration
  def self.up
    create_table :special_dates do |t|
      t.date    "week_of",             :null    => false
      t.integer "congregation_id"
      t.string  "event",               :limit   => 20,    :null => false
      t.string  "description",         :limit   => 50
      t.boolean "is_cancelled",        :default => true,  :null => false
      t.boolean "is_review_postponed", :default => false, :null => false
      t.timestamps
    end

    add_index :special_dates, [:week_of, :congregation_id], :unique => true
  end

  def self.down
    drop_table :special_dates
  end
end
