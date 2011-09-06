class StudentAssignment < Assignment

  belongs_to :lesson

  validates_presence_of :substitute, :if => :state_requires_substitute
  validates_presence_of :lesson, :if => :state_requires_lesson

  attr_accessible :lesson_chapter, :lesson_status, :lesson_next, :lesson_notes, :setting_number

  before_save :prepare_lesson

  state_machine do
    after_transition :assigned => :completed, :do => :finalize_lesson
    end

    def display
      # TODO Update this to display properly without being dependent on output format
      if student
        output = "Student: " + student.display_name
        if lesson
          output += " " + lesson.display
        end
      end
    end

    def lesson_chapter
      if lesson
        lesson.lesson_source.chapter
      end
    end

    def lesson_chapter=( chapter )
      chapter = chapter.to_i if chapter
      if chapter && student && ( chapter >= 1 && chapter <= LESSON_SOURCES_COUNT )
        lesson_source_id = student.congregation.language.lesson_sources.where( :chapter => chapter ).first.id
        pending_lesson = student.lessons.pending.where( :lesson_source_id => lesson_source_id ).first
        if pending_lesson
          self.lesson = pending_lesson
        else
          self.lesson = student.lessons.create(
            :lesson_source => student.congregation.language.lesson_sources.where( :chapter => chapter ).first,
            :date_started => school( true ).school_session.week_of )
        end
      end
    end

    def setting_number
      if setting
        setting.setting_source.number
      end
    end

    def setting_number=( number )
      number = number.to_i if number
      if( number && 
         number >= 1 && number <= SETTING_SOURCES_COUNT &&
         student && 
         student.instance_of?( Sister ) )

        setting_source = student.congregation.language.setting_sources.where( :number => number ).first
        self.setting = student.settings.create( :setting_source => setting_source, :date_used => week_of )
      end
    end

    def find_eligible_assistants
      join = %Q{
      left outer join
      (
        select assignments.*
        from assignments
        join
        (
          select max(b.id) as assignment_id
          from
          (
            select x.assistant_id, max(x.week_of) as latest_date
            from assignments x
            where x.assistant_id is not null
            group by x.assistant_id
          ) a
          join assignments b
          on a.assistant_id = b.assistant_id and a.latest_date = b.week_of
          group by b.assistant_id
        ) la
        on assignments.id = la.assignment_id
      ) las
      on students.id = las.assistant_id
      left outer join students stu
      on las.student_id = stu.id
      }

      results = school_session.congregation.students.
        select( "students.id, students.display_name, students.last_name, students.first_name, las.week_of as latest_date, stu.display_name as last_assisted_name")
      results = results.where( "students.id <> ?", student.id.to_s ) if student
      results = results.where( :is_active => true, :use_for_assistant => true ).
        joins( join ).
        order( "las.week_of, students.last_name, students.first_name")

    end

    protected

    def assignable?
      return student && lesson
    end

    def completable?
      if completed_by == "student"
        return true if student && lesson_status
      end
      return false
    end

    private

    def finalize_lesson
      week_of = school( true ).school_session.week_of
      if lesson_status == "complete"
        lesson.date_completed = week_of
      elsif lesson_status == "incomplete"
        lesson.date_completed = nil
      end
      lesson.lesson_histories.create( :assignment_date => week_of, :notes => lesson_notes )
      if lesson_next && lesson_next.to_i <= LESSON_SOURCES_COUNT
        self.student.next_lesson = lesson_next
      end
    end

    def prepare_lesson
      if (not student) && lesson
        if lesson.date_started == school( true ).school_session.week_of
          lesson.date_started = nil
          lesson.date_completed = nil
          lesson.save
        end
        self.lesson = nil
      end
      if lesson
        self.lesson.date_started ||= school( true ).school_session.week_of
      end
    end

    def prep_substitution
      if lesson
        lesson.date_started = nil if lesson.date_started == school( true ).school_session.week_of
        lesson.save
      end
      self.lesson = nil
    end

    def prep_completion_undo
      lesson_history = lesson.lesson_histories.find_by_assignment_date( school( true ).school_session.week_of )
      if lesson_history
        lesson_history.destroy
      end
      lesson.date_completed = nil
    end

    def state_requires_substitute
      state == "substituted"
    end

    def state_requires_lesson
      ["assigned", "completed"].include?( state )
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

