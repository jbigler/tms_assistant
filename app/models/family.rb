class Family < ActiveRecord::Base

  belongs_to :congregation
  has_many :students

  validates_presence_of :name, :congregation_id

  attr_accessible :name

  def first_name
    students.empty? ? "" : students[0].first_name
  end
end

# == Schema Information
#
# Table name: families
#
#  id              :integer         primary key
#  name            :string(100)     not null
#  congregation_id :integer         not null
#  created_at      :timestamp
#  updated_at      :timestamp
#

