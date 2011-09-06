class School < ActiveRecord::Base

  belongs_to :school_session
  acts_as_list :scope => :school_session

  belongs_to :talk_no1,
             :dependent => :delete,
             :autosave => true
  belongs_to :talk_no2,
             :dependent => :delete,
             :autosave => true
  belongs_to :talk_no3,
             :dependent => :delete,
             :autosave => true

  validates_presence_of :school_session_id

  after_create :create_assignments

  attr_accessible :talk_no1_attributes, :talk_no2_attributes, :talk_no3_attributes
  accepts_nested_attributes_for :talk_no1, :talk_no2, :talk_no3

  state_machine :initial => :unassigned do
    before_transition :completed  => :assigned,   :do => :undo_completion
    after_transition  any         => :cancelled,  :do => :clear_assignments
    after_transition  :cancelled  => :unassigned, :do => :create_assignments
    after_transition  :unassigned => :assigned,   :do => :assign_all_assignments
    after_transition  :assigned   => :unassigned, :do => :unassign_all_assignments
    after_transition  :assigned   => :completed,  :do => :complete_all_assignments

    event :assign do
      transition :unassigned => :assigned, :if => :assignable?
    end

    event :unassign do
      transition :assigned => :unassigned
    end

    event :complete do
      transition :assigned => :completed, :if => :completable?
    end

    event :undo do
      transition :completed => :assigned
    end

    event :cancel do
      transition any => :cancelled
    end

    event :reactivate do
      transition :cancelled => :unassigned
    end

  end

  private

    def completable?
      return ( talk_no1.can_complete? || talk_no1.is_cancelled? ) && 
             ( talk_no2.can_complete? || talk_no2.is_cancelled? ) && 
             ( talk_no3.can_complete? || talk_no3.is_cancelled? )
    end

    def assign_all_assignments
      talk_no1.is_cancelled? ? talk_no1.cancel : talk_no1.assign
      talk_no2.is_cancelled? ? talk_no2.cancel : talk_no2.assign
      talk_no3.is_cancelled? ? talk_no3.cancel : talk_no3.assign
    end

    def unassign_all_assignments
      talk_no1.is_cancelled? ? talk_no1.restore : talk_no1.unassign
      talk_no2.is_cancelled? ? talk_no2.restore : talk_no2.unassign
      talk_no3.is_cancelled? ? talk_no3.restore : talk_no3.unassign
    end

    def assignable?
      return ( talk_no1.can_assign? || talk_no1.is_cancelled? ) && 
             ( talk_no2.can_assign? || talk_no2.is_cancelled? ) && 
             ( talk_no3.can_assign? || talk_no3.is_cancelled? )
    end

    def complete_all_assignments
      talk_no1.complete unless talk_no1.cancelled?
      talk_no2.complete unless talk_no2.cancelled?
      talk_no3.complete unless talk_no3.cancelled?
    end

    def undo_completion
      talk_no1.undo unless talk_no1.cancelled?
      talk_no2.undo unless talk_no2.cancelled?
      talk_no3.undo unless talk_no3.cancelled?
    end

    def create_assignments
      schedule = school_session.congregation.language.schedules.find_by_week_of( school_session.week_of )
      if schedule
        self.create_talk_no1( :schedule_item => schedule.talk_no1, :week_of => school_session.week_of )
        self.create_talk_no2( :schedule_item => schedule.talk_no2, :week_of => school_session.week_of )
        self.create_talk_no3( :schedule_item => schedule.talk_no3, :week_of => school_session.week_of )
        self.save
      end
    end

    def clear_assignments
      if talk_no1
        self.talk_no1.destroy
        self.talk_no1 = nil
      end

      if talk_no2
        self.talk_no2.destroy
        self.talk_no2 = nil
      end

      if talk_no3
        self.talk_no3.destroy
        self.talk_no3 = nil
      end
    end
end


# == Schema Information
#
# Table name: schools
#
#  id                :integer         primary key
#  school_session_id :integer
#  talk_no1_id       :integer
#  talk_no2_id       :integer
#  talk_no3_id       :integer
#  position          :integer
#  state             :string(20)
#  created_at        :timestamp
#  updated_at        :timestamp
#

