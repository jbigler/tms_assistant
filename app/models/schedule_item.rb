class ScheduleItem < ActiveRecord::Base
  attr_accessible :source, :title, :for_adult_only, :for_advanced_only, :for_brother_only
end

# == Schema Information
#
# Table name: schedule_items
#
#  id                :integer         primary key
#  title             :string(100)
#  source            :string(50)
#  for_brother_only  :boolean         default(FALSE), not null
#  for_adult_only    :boolean         default(FALSE), not null
#  for_advanced_only :boolean         default(FALSE), not null
#  created_at        :timestamp
#  updated_at        :timestamp
#

