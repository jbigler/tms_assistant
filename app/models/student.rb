class Student < ActiveRecord::Base

  belongs_to :congregation
  belongs_to :family
  has_many :unavailable_dates, :dependent => :destroy
  has_many :lessons, :autosave => true, :dependent => :destroy
  has_many :assignments, :dependent => :nullify
  has_many :substituted_assignments,
           :dependent => :nullify,
           :class_name => "Assignment",
           :foreign_key => "substitute_id"

  validates_presence_of :first_name, :last_name, :congregation_id
  validates_inclusion_of :type, :in => ["Brother", "Sister"]

  attr_accessible :first_name,             
    :middle_name,
    :last_name,              
    :family_id,
    :display_name,           
    :telephone,              
    :email,                  
    :notes,
    :is_active,              
    :use_for_advanced,       
    :use_for_adult,          
    :use_in_main_school,     
    :use_in_secondary_school,
    :use_for_reader,         
    :use_for_bh,               
    :use_for_no1,            
    :use_for_no2,            
    :use_for_no3,            
    :use_for_assistant,
    :type

  #Returns a collection of lessons applicable for
  #this student on the provided assignment.
  #Only returns chapter, description, date_started, and date_completed
  def find_eligible_lessons( assignment )
    if assignment && assignment.is_a?( Assignment )
      if self.is_a?( Sister )
        lesson_type = "use_for_demonstration"
      else
        lesson_type = case assignment
          when TalkNo1 then "use_for_reading"
          when TalkNo2 then "use_for_demonstration"
          when TalkNo3 then "use_for_discourse"
        end
      end
      congregation.language.lesson_sources.
        select( "lesson_sources.chapter, lesson_sources.description, l.date_started, l.date_completed" ).
        joins( "left outer join (select lesson_source_id, max(date_started) as date_started, max(date_completed) as date_completed from lessons where student_id = " + self.id.to_s + " group by lesson_source_id ) l on lesson_sources.id = l.lesson_source_id" ).
        where( lesson_type.to_sym => true )
    else
      raise ArgumentError, "requires an assignment"
    end
  end

  def self.inherited( child )
    child.instance_eval do
      def model_name
        Student.model_name
      end
    end
    super
  end
  
end

# == Schema Information
#
# Table name: students
#
#  id                      :integer         primary key
#  first_name              :string(50)
#  last_name               :string(50)
#  display_name            :string(100)
#  telephone               :string(15)
#  email                   :string(150)
#  notes                   :text
#  type                    :string(20)
#  is_active               :boolean         default(TRUE), not null
#  use_for_advanced        :boolean         default(FALSE), not null
#  use_for_adult           :boolean         default(TRUE), not null
#  use_in_main_school      :boolean         default(TRUE), not null
#  use_in_secondary_school :boolean         default(TRUE), not null
#  use_for_reader          :boolean         default(FALSE), not null
#  use_for_bh              :boolean         default(FALSE), not null
#  use_for_no1             :boolean         default(FALSE), not null
#  use_for_no2             :boolean         default(FALSE), not null
#  use_for_no3             :boolean         default(FALSE), not null
#  use_for_assistant       :boolean         default(FALSE), not null
#  congregation_id         :integer
#  created_at              :timestamp
#  updated_at              :timestamp
#  family_id               :integer
#  middle_name             :string(50)
#  next_lesson             :integer
#

