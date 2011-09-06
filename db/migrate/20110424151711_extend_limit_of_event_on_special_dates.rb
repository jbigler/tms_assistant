class ExtendLimitOfEventOnSpecialDates < ActiveRecord::Migration
  def self.up
    change_column( :special_dates, :event, :string, :limit => 50 )
  end

  def self.down
    change_column( :special_dates, :event, :string, :limit => 20 )
  end
end
