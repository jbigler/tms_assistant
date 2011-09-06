class Congregation < ActiveRecord::Base

  belongs_to :language
  has_and_belongs_to_many :users
  has_many :families, :dependent => :delete_all, :autosave => true
  has_many :students, :dependent => :destroy, :autosave => true
  has_many :school_sessions, :dependent => :destroy, :autosave => true
  has_many :special_dates, :dependent => :delete_all, :autosave => true

  validates_presence_of :number_of_schools, :language_id, :name

  attr_accessible :number_of_schools, :language_id, :name, :meeting_day

end

# == Schema Information
#
# Table name: congregations
#
#  id                :integer         primary key
#  name              :string(150)     not null
#  number_of_schools :integer         default(1), not null
#  language_id       :integer
#  created_at        :timestamp
#  updated_at        :timestamp
#  meeting_day       :integer
#

