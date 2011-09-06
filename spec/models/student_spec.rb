require 'spec_helper'

describe Student do

  it { should belong_to( :congregation ) }
  it { should belong_to( :family ) }
  it { should have_many( :lessons ) }
  it { should have_many( :assignments ) }
  it { should have_many( :substituted_assignments ) }

  it { should validate_presence_of( :first_name ) }
  it { should validate_presence_of( :last_name ) }
  it { should validate_presence_of( :congregation_id ) }

end
