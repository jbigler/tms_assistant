class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.references :school_session
      t.references :talk_no1
      t.references :talk_no2
      t.references :talk_no3
      t.integer   :position
      t.string    :state,         :limit => 20
      t.timestamps
    end

    add_index :schools, [:school_session_id, :position]
    add_index :schools, :school_session_id
  end

  def self.down
    drop_table :schools
  end
end
