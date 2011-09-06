class CreateCongregations < ActiveRecord::Migration
  def self.up
    create_table :congregations do |t|
      t.string     :name,              :null        => false, :limit   => 150
      t.integer    :number_of_schools, :null        => false, :default => 1
      t.references :language,          :foreign_key => true
      t.timestamps
    end
    add_index :congregations, :name, :name => "index_congregations_on_name"
  end

  def self.down
    drop_table :congregations
  end
end
