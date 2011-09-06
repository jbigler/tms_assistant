class Lesson < ActiveRecord::Base

  belongs_to :lesson_source
  belongs_to :student
  has_many :assignments
  has_many :lesson_histories, :autosave => true, :dependent => :delete_all

  validates_presence_of :lesson_source_id, :student_id

  attr_accessible :date_started, :date_completed, :exercises_completed, :notes, :lesson_source

  scope :completed, where( "date_completed is not null" )
  scope :pending, where( "date_completed is null" )

  def display
    lesson_source.to_s
  end

end

# == Schema Information
#
# Table name: lessons
#
#  id                  :integer         primary key
#  student_id          :integer         not null
#  lesson_source_id    :integer         not null
#  date_started        :date
#  date_completed      :date
#  exercises_completed :boolean         default(FALSE), not null
#  notes               :text
#  created_at          :timestamp
#  updated_at          :timestamp
#

