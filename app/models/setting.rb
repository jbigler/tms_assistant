class Setting < ActiveRecord::Base

  belongs_to :setting_source
  belongs_to :sister, :foreign_key => "student_id"

  validates_presence_of :setting_source_id
  attr_accessible :date_used, :setting_source

end

# == Schema Information
#
# Table name: settings
#
#  id                :integer         primary key
#  setting_source_id :integer         not null
#  student_id        :integer         not null
#  date_used         :date
#  notes             :text
#  created_at        :timestamp
#  updated_at        :timestamp
#

