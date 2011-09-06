class UnavailableDate < ActiveRecord::Base

  belongs_to :student

  validate :must_be_monday
  validates_presence_of :start_date, :student_id
  validates_uniqueness_of :start_date, :scope => :student_id

  attr_accessible :start_date, :end_date, :reason

  def end_date
    if read_attribute( :end_date )
      read_attribute( :end_date )
    else
      read_attribute( :start_date )
    end
  end

  private

  def must_be_monday
    errors.add( :start_date, "Day of week must be a Monday." ) unless start_date && start_date.wday == 1
    errors.add( :end_date, "Day of week must be a Monday." ) unless end_date && end_date.wday == 1
  end
end



# == Schema Information
#
# Table name: unavailable_dates
#
#  id         :integer         primary key
#  start_date :date
#  end_date   :date
#  reason     :string(255)
#  student_id :integer
#  created_at :timestamp
#  updated_at :timestamp
#

