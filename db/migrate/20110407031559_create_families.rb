class CreateFamilies < ActiveRecord::Migration
  def self.up
    create_table :families do |t|
      t.string     :name,        :limit => 100, :null => false
      t.references :congregation, :null => false
      t.timestamps
    end

    add_index :families, [:congregation_id, :name]
    add_column :students, :family_id, :integer, :null => true
  end

  def self.down
    drop_table :families
    remove_column :students, :family_id
  end
end
