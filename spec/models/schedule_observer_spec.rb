require 'spec_helper'

describe ScheduleObserver do

  context "with a Congregation" do
    before( :all ) do
      @congregation = FactoryGirl.create( :congregation )
    end

    after( :all ) do
      language = @congregation.language
      @congregation.destroy
      language.destroy
    end

    context "and a normal SchoolSession" do
      before( :each ) do
        @session = @congregation.school_sessions.create( :week_of => Date.civil( 2011, 4, 4) )
      end

      context "when Schedule is changed to a review" do
        before( :each ) do
          @schedule = @congregation.language.schedules.find_by_week_of( @session.week_of )
          @schedule.has_review = true
        end
        
        it "should destroy the SchoolSession" do
          expect{ @schedule.save }.to change{ SchoolSession.count }.by( -1 )
        end
      end
    end

    context "and a review SchoolSession" do
      before( :each ) do
        review_schedule = FactoryGirl.create( :review_schedule, :language => @congregation.language )
        @session = @congregation.school_sessions.create( :week_of => review_schedule.week_of )
      end

      context "when the review attribute is cleared from the Schedule" do
        before( :each ) do
          @schedule = @congregation.language.schedules.find_by_week_of( @session.week_of )
          @schedule.has_review = false
        end
        
        it "should destroy the SchoolSession" do
          expect{ @schedule.save }.to change{ SchoolSession.count }.by( -1 )
        end
      end
    end
  end
end
