class TalkNo3 < StudentAssignment

  has_one :school
  has_one :school_session, :through => :school
  belongs_to :assistant, :class_name => "Sister", :foreign_key => :assistant_id
  belongs_to :setting

  before_save :process_changes

  def abbrev
    "3"
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
    if student && student.instance_of?( Sister )
      return true
    end
    return false
  end

  def assignable?
    if student
      if student.instance_of?( Sister )
        return lesson && assistant
      else
        return lesson
      end
    end
  end

  def completable?
    if completed_by == "student"
      if student.instance_of?( Sister )
        return true if student && lesson_status && assistant
      else
        return true if student && lesson_status
      end
    end
    return false
  end

  def substitutable?
    if completed_by == "substitute"
      if student.instance_of?( Sister )
        return true if substitute && assistant
      else
        return true if substitute
      end
    end
    return false
  end

  private

  def process_changes
    if student && student.instance_of?( Brother )
      if assistant
        self.assistant = nil
      end
    end

    if student_id_changed? && student_id_was != nil
      if lesson
        self.lesson.date_started = nil if lesson.date_started == school.school_session.week_of
        self.lesson = nil
      end
    end
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

