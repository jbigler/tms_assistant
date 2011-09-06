class AddMeetingDayToCongregation < ActiveRecord::Migration
  def self.up
    add_column :congregations, :meeting_day, :integer
  end

  def self.down
    remove_column :congregations, :meeting_day
  end
end
