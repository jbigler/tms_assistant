require 'spec_helper'

describe SpecialDateObserver do

  context "with a SchoolSession" do

    before( :all ) do
      @congregation = FactoryGirl.create( :congregation )
    end

    after( :all ) do
      language = @congregation.language
      @congregation.destroy
      language.destroy
    end

    before( :each ) do
      @schedule = FactoryGirl.create( :schedule, :language => @congregation.language )
    end

    it "should delete the SchoolSession when a SpecialDate is created for that week" do
      session = @congregation.school_sessions.create( :week_of => @schedule.week_of )
      expect {
        FactoryGirl.create( :district_convention, 
                            :week_of => session.week_of, 
                            :congregation => @congregation )
      }.to change{ SchoolSession.count }.by( -1 )
    end

    context "and a District Convention SpecialDate exists" do
      before( :each ) do
        @special_date = FactoryGirl.create( :district_convention, 
                                        :week_of => @schedule.week_of, 
                                        :congregation => @congregation )

      end

      it "should automatically cancel any session created for that date" do
        @session = @congregation.school_sessions.create( :week_of => @schedule.week_of )
        @session.should be_cancelled
      end
    end
  end
end

