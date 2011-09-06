require 'spec_helper'

describe Assignment do
  it { should belong_to( :student ) }
  it { should belong_to( :schedule_item ) }
  it { should belong_to( :substitute ) }

  it { should validate_presence_of( :week_of ) }
end
