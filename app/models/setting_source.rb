class SettingSource < ActiveRecord::Base

  has_many :settings
  belongs_to :language

  validates_presence_of :number, :language_id
  validates_uniqueness_of :number, :scope => :language_id

  attr_accessible :description
end

# == Schema Information
#
# Table name: setting_sources
#
#  id          :integer         primary key
#  language_id :integer
#  number      :integer         not null
#  description :string(200)     default(""), not null
#  created_at  :timestamp
#  updated_at  :timestamp
#

