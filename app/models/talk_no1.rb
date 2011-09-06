class TalkNo1 < StudentAssignment

  has_one :school
  has_one :school_session, :through => :school

  def abbrev
    "1"
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

