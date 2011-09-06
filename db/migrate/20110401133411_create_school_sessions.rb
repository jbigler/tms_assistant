class CreateSchoolSessions < ActiveRecord::Migration
  def self.up
    create_table :school_sessions do |t|
      t.date       :week_of,         :null  => false
      t.references :bible_highlights
      t.references :reader
      t.references :congregation
      t.string     :state,           :limit => 20
      t.timestamps
    end

    add_index :school_sessions, [:week_of, :congregation_id]
  end

  def self.down
    drop_table :school_sessions
  end
end
