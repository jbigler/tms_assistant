require 'spec_helper'

describe SettingSource do

  it { should belong_to( :language ) }
  it { should validate_presence_of( :number ) }
  it { should validate_presence_of( :language_id ) }
  it { should allow_mass_assignment_of( :description ) }

end
