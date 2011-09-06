require 'spec_helper'

describe Family do

  it { should belong_to( :congregation ) }
  it { should have_many( :students ) }

  it { should validate_presence_of( :name ) }
  it { should validate_presence_of( :congregation_id ) }

end
