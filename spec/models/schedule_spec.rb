require 'spec_helper'

describe Schedule do

  before( :all ) do
    @language = FactoryGirl.create( :language )
  end

  after( :all ) do
    @language.destroy
  end

  before( :each ) do
    @schedule = FactoryGirl.create( :schedule, :language => @language )
  end

  it { should belong_to( :language ) }
  it { should belong_to( :bible_highlights ) }
  it { should belong_to( :talk_no1 ) }
  it { should belong_to( :talk_no2 ) }
  it { should belong_to( :talk_no3 ) }

  it { should validate_presence_of( :week_of ) }
  it { should validate_presence_of( :language_id ) }

  it "should fail if it's not set for a Monday" do
    schedule1 = Schedule.new
    schedule1.week_of = Date.civil( 2008, 4, 8 )
    schedule1.should have(1).error_on( :week_of )
  end

  it "should strip the time from the date saved" do
    schedule1 = Schedule.new
    schedule1.week_of = DateTime.civil( 2008, 5, 12, 9, 30, 0, -800 )
    schedule1.valid?
    schedule1.week_of.should == Date.civil( 2008, 5, 12 )
  end

  context "when the schedule does not have a review" do
    it "should create all student schedule_items" do
      @schedule.bible_highlights.should_not be_nil
      @schedule.talk_no1.should_not be_nil
      @schedule.talk_no2.should_not be_nil
      @schedule.talk_no3.should_not be_nil
    end

    context "and then is changed to a review" do
      it "should destroy the student ScheduleItems" do
        @schedule.has_review = true
        @schedule.save
        @schedule.talk_no1.should be_nil
        @schedule.talk_no2.should be_nil
        @schedule.talk_no3.should be_nil
      end
    end
  end

  context "when the schedule does have a review" do
    before( :each ) do
      @review_schedule = @review_schedule ||= FactoryGirl.create( :review_schedule, :language => @language )
    end

    it "should create no student schedule_items" do
      @review_schedule.bible_highlights.should_not be_nil
      @review_schedule.talk_no1.should be_nil
      @review_schedule.talk_no2.should be_nil
      @review_schedule.talk_no3.should be_nil
    end

    context "and then is changed to have no review" do
      it "should create the student ScheduleItems" do
        @review_schedule.has_review = false
        @review_schedule.save
        @review_schedule.talk_no1.should_not be_nil
        @review_schedule.talk_no2.should_not be_nil
        @review_schedule.talk_no3.should_not be_nil
      end
    end
  end
end
