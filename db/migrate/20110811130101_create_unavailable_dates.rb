class CreateUnavailableDates < ActiveRecord::Migration
  def change
    create_table :unavailable_dates do |t|
      t.date :start_date
      t.date :end_date
      t.string :reason
      t.references :student

      t.timestamps
    end
    add_index :unavailable_dates, :student_id
    add_index :unavailable_dates, :start_date
    add_index :unavailable_dates, :end_date
    add_index :unavailable_dates, [:start_date, :end_date]
  end
end
