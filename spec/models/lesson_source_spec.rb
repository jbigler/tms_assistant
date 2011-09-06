require 'spec_helper'

describe LessonSource do
  
  it { should belong_to( :language ) }
  it { should validate_presence_of( :chapter ) }
  it { should validate_presence_of( :language_id ) }
  #it { should validate_uniqueness_of( :chapter ).scoped_to( :language_id ) }
  it { should allow_mass_assignment_of( :description ) }
  it { should allow_mass_assignment_of( :page_number ) }

end
