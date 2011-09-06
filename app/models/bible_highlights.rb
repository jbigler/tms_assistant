class BibleHighlights < Assignment

  has_one :school_session, :foreign_key => "bible_highlights_id"

  validates_associated :school_session

  def abbrev
    "BH"
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

