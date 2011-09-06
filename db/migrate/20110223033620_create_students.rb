class CreateStudents < ActiveRecord::Migration

  def self.up
    create_table :students do |t|
      t.string  :first_name,              :limit   => 50
      t.string  :last_name,               :limit   => 50
      t.string  :display_name,            :limit   => 100
      t.string  :telephone,               :limit   => 15
      t.string  :email,                   :limit   => 150
      t.text    :notes
      t.string  :type,                    :limit   => 20
      t.boolean :is_active,               :default => true,  :null => false
      t.boolean :use_for_advanced,        :default => false, :null => false
      t.boolean :use_for_adult,           :default => true,  :null => false
      t.boolean :use_in_main_school,      :default => true,  :null => false
      t.boolean :use_in_secondary_school, :default => true,  :null => false
      t.boolean :use_for_reader,          :default => false, :null => false
      t.boolean :use_for_bh,              :default => false, :null => false
      t.boolean :use_for_no1,             :default => false, :null => false
      t.boolean :use_for_no2,             :default => false, :null => false
      t.boolean :use_for_no3,             :default => false, :null => false
      t.boolean :use_for_assistant,       :default => false, :null => false
      t.integer :congregation_id
      t.timestamps
    end

    add_index :students, :last_name

  end

  def self.down
    drop_table :students
  end
end
