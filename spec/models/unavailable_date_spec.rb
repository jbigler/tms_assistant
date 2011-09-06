require 'spec_helper'

describe UnavailableDate do

  it { should belong_to( :student ) }
  it { should validate_presence_of( :start_date ) }
  it { should validate_presence_of( :student_id ) }
  it { should allow_mass_assignment_of( :start_date ) }
  it { should allow_mass_assignment_of( :end_date ) }
  it { should allow_mass_assignment_of( :reason ) }

  it { should allow_value( Date.civil( 2011, 8, 15 ) ).for( :start_date ) }
  it { should_not allow_value( Date.civil( 2011, 8, 16 ) ).for( :start_date ) }

  it { should allow_value( Date.civil( 2011, 8, 15 ) ).for( :end_date ) }
  it { should_not allow_value( Date.civil( 2011, 8, 16 ) ).for( :end_date ) }

  context "with a student assigned" do
    before( :each ) do
      @student = mock_model( Brother )
      @ud = UnavailableDate.new
      @ud.student = @student
    end

    it "should assign the end_date to be the start_date if no end_date is given" do
      @ud.start_date = Date.civil( 2011, 8, 15 )
      @ud.end_date.should == Date.civil( 2011, 8, 15 )
    end

    it "should use the given end_date if provided" do
      @ud.start_date = Date.civil( 2011, 8, 15 )
      @ud.end_date = Date.civil( 2011, 8, 22 )
      @ud.end_date.should == Date.civil( 2011, 8, 22 )
    end
  end
end
