class SpecialDate < ActiveRecord::Base

  belongs_to :congregation

  validates_presence_of :event, :congregation_id, :week_of
  validates_inclusion_of :event, :in => SPECIAL_DATE_EVENTS, :message => "Invalid event"
  validates_presence_of :description, :if => Proc.new { |special_date| special_date.event == "Other" }

  validates_uniqueness_of :week_of, :scope => [:congregation_id]
  validate :must_be_monday

  before_save :set_event_attributes

  attr_accessible :week_of, :event, :description, :is_cancelled, :is_review_postponed

  protected

  def must_be_monday
    errors.add( :week_of, "Day of week for schedule must be a Monday." ) unless week_of && week_of.wday == 1
  end

  def set_event_attributes
    case event
    when "Circuit Assembly"
      self.is_cancelled = true
      self.is_review_postponed = true
    when "District Convention"
      self.is_cancelled = true
      self.is_review_postponed = false
    when "Circuit Overseer Visit"
      self.is_cancelled = false
      self.is_review_postponed = true
    when "Special Assembly Day"
      self.is_cancelled = true
      self.is_review_postponed = false
    end
    true
  end
end


# == Schema Information
#
# Table name: special_dates
#
#  id                  :integer         primary key
#  week_of             :date            not null
#  congregation_id     :integer
#  event               :string(50)      not null
#  description         :string(50)
#  is_cancelled        :boolean         default(TRUE), not null
#  is_review_postponed :boolean         default(FALSE), not null
#  created_at          :timestamp
#  updated_at          :timestamp
#

