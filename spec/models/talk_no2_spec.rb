require 'spec_helper'

describe TalkNo2 do

  before( :all ) do
    @language = FactoryGirl.create( :language )
    @congregation = FactoryGirl.create( :congregation, :language => @language )
  end

  after( :all ) do
    @congregation.destroy
    @language.destroy
  end

  let( :first_school ) do
    schedule = FactoryGirl.create( :schedule, :language => @language )
    session = FactoryGirl.create( :normal_school_session, :week_of => schedule.week_of, :congregation => @congregation )
    session.schools.first
  end

  let( :no2 ) { first_school.talk_no2 }

  it { should have_one( :school ) }
  it { should have_one( :school_session ).through( :school ) }
  it { should belong_to( :lesson ) }

  context "with a student assigned" do
    before( :each ) do
      no2.student = FactoryGirl.create( :sister, :congregation => @congregation )  
    end

    it "should be valid" do
      no2.should be_valid
    end

    it "should not be able to be assigned" do
      no2.can_assign?.should be_false
    end

    context "and an assistant assigned" do
      before( :each ) do
        no2.assistant = FactoryGirl.create( :sister, :congregation => @congregation )
      end

      it "should be valid" do
        no2.should be_valid
      end

      it "should not be able to be assigned" do
        no2.can_assign?.should be_false
      end
      
      context "and a valid lesson assigned" do
        before( :each ) do
          no2.lesson_chapter = 1
        end

        it "should be able to be assigned" do
          no2.can_assign?.should be_true
        end

        context "that has been assigned" do
          before( :each ) do
            no2.assign
            no2.completed_by = "student"
            no2.lesson_status = "complete"
          end

          it "should be in the assigned state" do
            no2.should be_assigned
          end
        end
      end
    end
  end
end
