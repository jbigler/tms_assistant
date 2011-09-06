require 'spec_helper'

describe SpecialDate do

  it { should belong_to( :congregation ) }
  it { should validate_presence_of( :event ) }
  it { should validate_presence_of( :congregation_id ) }
  it { should validate_presence_of( :week_of ) }
  it { should_not allow_value( "Not a real event" ).for( :event ) }

  it { should allow_value( Date.civil( 2011, 8, 15 ) ).for( :week_of ) }
  it { should_not allow_value( Date.civil( 2011, 8, 16 ) ).for( :week_of) }


  context "when the event is set to Other" do
    before( :each ) do
      @special_date = SpecialDate.new
      @special_date.event = "Other"
    end

    it "should validate the presence of the description" do
      @special_date.valid?
      @special_date.errors.keys.should include( :description )
      @special_date.description = "Sample description."
      @special_date.valid?
      @special_date.errors.keys.should_not include( :description )
    end
  end
end
