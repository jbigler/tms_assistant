class LessonHistory < ActiveRecord::Base

  belongs_to :lesson

  validates_presence_of :lesson_id, :assignment_date

  attr_accessible :assignment_date, :notes

end

# == Schema Information
#
# Table name: lesson_histories
#
#  id              :integer         primary key
#  lesson_id       :integer         not null
#  assignment_date :date            not null
#  notes           :text
#  created_at      :timestamp
#  updated_at      :timestamp
#

