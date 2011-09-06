class TalkNo2 < StudentAssignment

  has_one :school
  has_one :school_session, :through => :school
  belongs_to :assistant, :class_name => "Sister", :foreign_key => :assistant_id
  belongs_to :setting

  def abbrev
    "2"
  end

  def display
    # TODO Update this to display properly without being dependent on output format
    if student
      output = "Student: " + student.full_name
      if lesson
        output += " " + lesson.display
      end
      if assistant
        output += " " + "Assistant: " + assistant.full_name
      end
    end
  end

  def has_assistant?
    return true
  end

  def assignable?
    return student && lesson && assistant
  end

  def completable?
    if completed_by == "student"
      return true if student && lesson_status && assistant
    end
    return false
  end

  def substitutable?
    if completed_by == "substitute"
      return true if substitute && assistant
    end
    return false
  end

end



# == Schema Information
#
# Table name: assignments
#
#  id               :integer         primary key
#  student_id       :integer
#  assistant_id     :integer
#  substitute_id    :integer
#  schedule_item_id :integer
#  week_of          :date            not null
#  type             :string(20)
#  state            :string(20)
#  completed_by     :string(255)
#  notes            :text
#  created_at       :timestamp
#  updated_at       :timestamp
#  lesson_id        :integer
#  lesson_status    :string(255)
#  lesson_next      :integer
#  lesson_notes     :text
#  setting_id       :integer
#  is_cancelled     :boolean         default(FALSE), not null
#

