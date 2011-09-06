class LessonSource < ActiveRecord::Base

  belongs_to :language
  has_many :lessons

  validates_presence_of :chapter, :language_id
  validates_uniqueness_of :chapter, :scope => :language_id

  attr_accessible :description, :page_number, :notes

  def to_s
    output = "Lesson: " + chapter.to_s
    if description
      output += " \"" + description + "\""
    end
  end

end

# == Schema Information
#
# Table name: lesson_sources
#
#  id                    :integer         primary key
#  language_id           :integer
#  chapter               :integer         not null
#  description           :string(150)     default(""), not null
#  page_number           :integer
#  use_for_reading       :boolean         default(FALSE), not null
#  use_for_demonstration :boolean         default(FALSE), not null
#  use_for_discourse     :boolean         default(FALSE), not null
#  notes                 :text
#  created_at            :timestamp
#  updated_at            :timestamp
#

