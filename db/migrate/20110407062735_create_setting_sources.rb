class CreateSettingSources < ActiveRecord::Migration
  def self.up
    create_table :setting_sources do |t|
      t.references :language
      t.integer    :number,      :null => false
      t.string     :description, :null => false, :default => "", :limit => 200

      t.timestamps
    end

    add_index :setting_sources, [:language_id, :number]
  end

  def self.down
    drop_table :setting_sources
  end
end
