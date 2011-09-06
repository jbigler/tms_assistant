class Schedule < ActiveRecord::Base

  belongs_to :bible_highlights,
             :class_name => "ScheduleItem",
             :autosave => true,
             :dependent => :delete
  belongs_to :talk_no1,
             :class_name => "ScheduleItem",
             :autosave => true,
             :dependent => :delete
  belongs_to :talk_no2,
             :class_name => "ScheduleItem",
             :autosave => true,
             :dependent => :delete
  belongs_to :talk_no3,
             :class_name => "ScheduleItem",
             :autosave => true,
             :dependent => :delete
  belongs_to :language

  before_validation :remove_time_from_date

  before_save :prep_bh, :prep_talks

  attr_accessible :week_of, :has_review, :bible_highlights_attributes, :talk_no1_attributes, :talk_no2_attributes, :talk_no3_attributes

  validates_presence_of :week_of, :language_id
  validates_uniqueness_of :week_of, :scope => :language_id
  validate :must_be_monday

  accepts_nested_attributes_for :bible_highlights, :talk_no1, :talk_no2, :talk_no3

  protected

  def remove_time_from_date
    if week_of
      date_with_no_time = Date.civil( week_of.year, week_of.month, week_of.day )
      self.week_of = date_with_no_time
    end
  end

  def prep_bh
    self.create_bible_highlights unless bible_highlights
  end

  def prep_talks
    if has_review?
      self.talk_no1.destroy if talk_no1
      self.talk_no1 = nil
      self.talk_no2.destroy if talk_no2
      self.talk_no2 = nil
      self.talk_no3.destroy if talk_no3
      self.talk_no3 = nil
    else
      self.create_talk_no1 unless talk_no1
      self.create_talk_no2 unless talk_no2
      self.create_talk_no3 unless talk_no3
    end
  end

  def must_be_monday
    errors.add( :week_of, "Day of week for schedule must be a Monday." ) unless week_of && week_of.wday == 1
  end
end

# == Schema Information
#
# Table name: schedules
#
#  id                  :integer         primary key
#  week_of             :date            not null
#  has_review          :boolean         default(FALSE), not null
#  language_id         :integer
#  bible_highlights_id :integer
#  talk_no1_id         :integer
#  talk_no2_id         :integer
#  talk_no3_id         :integer
#  created_at          :timestamp
#  updated_at          :timestamp
#

