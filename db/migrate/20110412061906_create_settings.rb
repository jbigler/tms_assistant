class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.references :setting_source, :null => false
      t.references :student, :null => false
      t.date :date_used
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
