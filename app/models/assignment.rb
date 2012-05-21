class Assignment < ActiveRecord::Base

  belongs_to :student
  belongs_to :schedule_item,
             :readonly => true
  belongs_to :substitute,
             :class_name => "Student",
             :foreign_key => :substitute_id

  validates_presence_of :week_of
  validates_presence_of :student, :if => :state_requires_student

  attr_readonly :week_of
  attr_accessible :student_id, :assistant_id, :substitute_id, :week_of, :completed_by, :notes, :schedule_item, :is_cancelled

  delegate :source, :title, :to => :schedule_item

  scope :latest, order( "assignments.week_of DESC" ).limit(2)

  attr_accessor :is_cancelled, :completed_by

  def is_cancelled?
    true if is_cancelled == 1
  end
  
  state_machine :initial => :unassigned do
    before_transition :assigned    => :substituted, :do => :prep_substitution
    before_transition :substituted => :assigned,    :do => :prep_substitution_undo
    before_transition :completed   => :assigned,    :do => :prep_completion_undo
    after_transition  :cancelled   => :unassigned,  :do => :process_cancellation_undo
    after_transition  any          => :cancelled,   :do => :process_cancellation

    event :cancel do
      transition [:unassigned, :assigned] => :cancelled
    end

    event :assign do
      transition :unassigned => :assigned, :if => :assignable?
    end

    event :complete do
      transition :assigned => :completed, :if => :completable?
      transition :assigned => :substituted, :if => :substitutable?
    end

    event :undo do
      transition [:assigned, :cancelled] => :unassigned
      transition [:completed, :substituted] => :assigned
    end
  end

  def display
    if student
      output = "Student: " + student.display_name
    end
  end

  def find_eligible_students
    assignment_type = self.class.to_s

    use_for_assignment = case self
      when BibleHighlights then "use_for_bh"
      when TalkNo1         then "use_for_no1"
      when TalkNo2         then "use_for_no2"
      when TalkNo3         then "use_for_no3"
      when Reader          then "use_for_reader"
    end

    join = %Q[
      left outer join
      (
        select assignments.* 
        from assignments
        join
        (
          select max(b.id) as assignment_id
          from
          (
            select x.student_id, max(x.week_of) as latest_date
            from assignments x
            group by x.student_id
          ) a
          join assignments b
          on a.student_id = b.student_id and a.latest_date = b.week_of
          group by b.student_id
        ) la
        on assignments.id = la.assignment_id
      ) las
      on students.id = las.student_id
      left outer join 
      (
        select student_id, reason from unavailable_dates
        where '#{week_of.to_s}' between start_date and end_date
      ) ud
      on students.id = ud.student_id
      left outer join schools
      on las.id = schools.talk_no1_id
      or las.id = schools.talk_no2_id
      or las.id = schools.talk_no3_id
    ]

    results = school_session.congregation.students.
      select( "students.id, students.display_name, students.first_name, students.last_name, las.type, las.week_of as latest_date, schools.position as school_no" ).
      joins( join )

    results = results.where( use_for_assignment.to_sym => true, :is_active => true )
    unless use_for_assignment == "use_for_reader"
      results = results.where( :use_for_advanced => true ) if schedule_item.for_advanced_only
      results = results.where( :use_for_adult => true ) if schedule_item.for_adult_only
      results = results.where( :type => "Brother" ) if schedule_item.for_brother_only
    end
    results = results.where("ud.reason is null")
    results.order( "las.week_of, students.last_name, students.first_name" ).all
  end

  def find_eligible_substitutes
    assignment_type = case self
      when BibleHighlights then "use_for_bh"
      when TalkNo1         then "use_for_no1"
      when TalkNo2         then "use_for_no2"
      when TalkNo3         then "use_for_no3"
      when Reader          then "use_for_reader"
    end

    results = school_session.congregation.students
    results = results.where( "students.id <> " + student.id.to_s ) if student
    results = results.where( assignment_type.to_sym => true, :is_active => true )
    unless assignment_type == "use_for_reader"
      results = results.where( :use_for_advanced => true ) if schedule_item.for_advanced_only
      results = results.where( :use_for_adult => true ) if schedule_item.for_adult_only
      results = results.where( :type => "Brother" ) if schedule_item.for_brother_only
    end
    results.order( "last_name, first_name" ).all
  end

  protected

  def assignable?
    return student
  end

  def completable?
    if completed_by == "student"
      return true if student
    end
    return false
  end

  def substitutable?
    if completed_by == "substitute"
      return true if substitute && student
    end
    return false
  end

  def prep_substitution
    true
  end

  def prep_substitution_undo
    self.substitute = nil
    self.lesson_status = nil
    self.lesson_next = nil
    self.lesson_notes = nil
    self.completed_by = nil
  end

  def prep_completion_undo
    self.lesson_status = nil
    self.lesson_next = nil
    self.lesson_notes = nil
    self.completed_by = nil
  end
  
  def process_cancellation
    self.student = nil
    self.substitute = nil
    self.lesson_status = nil
    self.lesson_next = nil
    self.lesson_notes = nil
    self.completed_by = nil
    if lesson and lesson.date_started == week_of
      self.lesson.destroy
      self.lesson = nil
    end
    save
  end

  def process_cancellation_undo
    self.is_cancelled = false
    save
  end

  def state_requires_student
    ["assigned", "completed", "substituted"].include?( state )
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

