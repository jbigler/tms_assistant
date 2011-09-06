class Sister < Student

  has_many :settings, :foreign_key => "student_id"
  has_many :assisted_assignments, 
           :class_name => "Assignment",
           :foreign_key => "assistant_id",
           :dependent => :nullify

  def sex
    return "F"
  end

  def find_eligible_settings
    congregation.language.setting_sources.
      select( "setting_sources.number, setting_sources.description, s.last_used" ).
      joins( "left outer join( select setting_source_id, max( date_used ) as last_used from Settings
           where student_id = " + id.to_s + " group by setting_source_id ) s on setting_sources.id = s.setting_source_id" ).
      order( "setting_sources.number" )
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

