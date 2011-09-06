class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.string :name,         :limit => 50, :null => false
      t.string :display_name, :limit => 50
      t.string :code,         :limit => 10
      t.timestamps
    end
  end

  def self.down
    drop_table :languages
  end
end
