class SchoolSession < ActiveRecord::Base

  scope :incomplete, lambda { where("state = 'assigned' and week_of <= ?", Date.today) }

  belongs_to :congregation
  belongs_to :reader, :dependent => :delete
  belongs_to :bible_highlights, :dependent => :delete
  has_many   :schools, :dependent => :destroy, :order => "position"

  validates_presence_of :week_of, :congregation_id
  validates_uniqueness_of :week_of, :scope => [:congregation_id]
  validate :must_be_monday

  before_validation :remove_time_from_date
  after_create :prepare_school_session

  attr_readonly :week_of, :congregation_id
  attr_accessible :week_of, :bible_highlights_attributes, :reader_attributes, :schools_attributes

  accepts_nested_attributes_for :bible_highlights, :reader, :schools

  state_machine :initial => :unassigned do
    before_transition any         => :cancelled,  :do => :clear_assignments
    before_transition :completed  => :assigned,   :do => :undo_completion
    after_transition  :cancelled  => :unassigned, :do => :prepare_school_session
    after_transition  :unassigned => :assigned,   :do => :assign_all_assignments
    after_transition  :assigned   => :unassigned, :do => :unassign_all_assignments
    after_transition  :assigned   => :completed,  :do => :complete_all_assignments

    event :assign do
      transition :unassigned => :assigned, :if => :assignable?
    end

    event :complete do
      transition :assigned => :completed, :if => :completable?
    end

    event :cancel do
      transition any - [:completed, :cancelled] => :cancelled
    end

    event :reactivate do
      transition :cancelled => :unassigned
    end

    event :undo do
      transition :assigned => :unassigned
      transition :completed => :assigned
    end

    state :cancelled do
    end
  end

  def prepare_school_session
    # Look up Schedule and SpecialDate information and use it to initialize the session

    schedule = congregation.language.schedules.find_or_create_by_week_of( week_of )
    special_date = congregation.special_dates.find_by_week_of( week_of )

    # Deal with SpecialDates first
    if special_date
      if special_date.is_cancelled?
        initialize_cancelled_session
        if special_date.is_review_postponed? &&
          ( self.has_review? || schedule.has_review? )
          create_review_session( week_of + 7.days )
        end
      else
        if( self.has_review? || schedule.has_review? )
          if( special_date.is_review_postponed? )
            initialize_normal_session( schedule, week_of + 7.days )
            create_review_session( week_of + 7.days )
          else
            initialize_normal_session( schedule )
          end
        else
          initialize_normal_session( schedule )
        end
      end
    else 
      if self.has_review? || schedule.has_review?
        initialize_review_session( schedule )
      else
        initialize_normal_session( schedule )
      end
    end
    self.save
  end
  
  def create_review_session( target_date )
    congregation.school_sessions.where( :week_of => target_date ).destroy_all
    congregation.school_sessions.create( :week_of => target_date, :has_review => true )
  end

  def initialize_normal_session( schedule, student_source_date = week_of )
    student_source_schedule = congregation.language.schedules.find_or_create_by_week_of( student_source_date )

    # Prepare Bible Highlighs as usual
    self.create_bible_highlights( :schedule_item => schedule.bible_highlights, :week_of => week_of )

    # Cancel the Review Reader Assignment
    self.reader.destroy if self.reader
    # not sure if this line is really necessary
    #self.reader = nil

    # Prepare schools
    if schools.empty?
      congregation.number_of_schools.times do
        self.schools.create
      end
    end
    if week_of != student_source_date
      schools.each do |school|
        school.talk_no1.schedule_item = student_source_schedule.talk_no1
        school.talk_no2.schedule_item = student_source_schedule.talk_no2
        school.talk_no3.schedule_item = student_source_schedule.talk_no3
      end
    end
  end

  def initialize_review_session( schedule )
    # Prepare Bible Highlighs as usual
    self.create_bible_highlights( :schedule_item => schedule.bible_highlights, :week_of => week_of )
    self.has_review = true

    # Prepare the Review Reader Assignment
    self.reader ||= self.create_reader( :week_of => week_of )

    # Clear out all schools
    self.schools.destroy_all
  end

  def initialize_cancelled_session
    # The cancel state will purge all assignments automatically.
    self.cancel
  end

  protected

  def assign_all_assignments
    bible_highlights.assign
    reader.assign if reader
    schools.each do |school|
      school.assign
    end
  end

  def unassign_all_assignments
    bible_highlights.undo
    reader.undo if reader
    schools.each do |school|
      school.undo
    end
  end

  def completable?
    result = bible_highlights.can_complete?
    if reader then result = result && reader.can_complete? end
    schools.each do |school|
      result = result && school.can_complete?
    end
    return result
  end

  def complete_all_assignments
    bible_highlights.complete
    if reader then reader.complete end
    schools.each do |school|
      school.complete
    end
  end

  def undo_completion
    bible_highlights.undo
    if reader then reader.undo end
    schools.each do |school|
      school.undo
    end
  end

  def remove_time_from_date
    if week_of?
      date_with_no_time = Date.civil( week_of.year, week_of.month, week_of.day )
      self.week_of = date_with_no_time
    end
  end

  def must_be_monday
    errors.add( :week_of, "Day of week for schedule must be a Monday." ) unless week_of && week_of.wday == 1
  end

  private

  def assignable?
    schools.each do |school|
      return false unless school.can_assign?
    end
    return false unless bible_highlights.can_assign?
    return false if reader && !reader.can_assign?
    return true
  end

  def clear_assignments
    if bible_highlights
      self.bible_highlights.destroy
      self.bible_highlights = nil
    end

    if reader
      self.reader.destroy
      self.reader = nil
    end

    self.schools.destroy_all
    self.schools.clear

  end
end


# == Schema Information
#
# Table name: school_sessions
#
#  id                  :integer         primary key
#  week_of             :date            not null
#  bible_highlights_id :integer
#  reader_id           :integer
#  congregation_id     :integer
#  state               :string(20)
#  created_at          :timestamp
#  updated_at          :timestamp
#  has_review          :boolean         default(FALSE)
#

