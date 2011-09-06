require 'spec_helper'

describe Setting do

  it { should belong_to( :sister ) }
  it { should belong_to( :setting_source ) }
  it { should validate_presence_of( :setting_source_id ) }

end
