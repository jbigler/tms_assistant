require 'spec_helper'

describe TalkNo1 do

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

  let( :no1 ) { first_school.talk_no1 }

  it { should have_one( :school ) }
  it { should have_one( :school_session ).through( :school ) }
  it { should belong_to( :lesson ) }

  it "should begin in the unassigned state" do
    no1.should be_unassigned
  end

  it "should not be able to be assigned" do
    no1.can_assign?.should be_false
  end

  context "with a student assigned" do
    before( :each ) do
      @brother = FactoryGirl.create(:brother, :congregation => @congregation)
      no1.student = @brother
    end

    it "should be the latest assignment for the student" do
      no1.save
      no1.student.assignments.latest.first.should eql(no1)
    end

    it "should not be able to be assigned" do
      no1.can_assign?.should be_false
    end

    it "should be valid" do
      no1.should be_valid
    end

    context "and a valid lesson assigned" do
      before( :each ) do
        no1.lesson_chapter = 1
      end

      it "should be able to be assigned" do
        no1.can_assign?.should be_true
      end

      context "that has been assigned" do
        before( :each ) do
          no1.assign
          no1.completed_by = "student"
          no1.lesson_status = "complete"
        end

        it "should be in the assigned state" do
          no1.should be_assigned
        end

        it "should set the lesson start date to the week of the school session" do
          no1.lesson.date_started.should == no1.school_session.week_of
        end

        it "should be able to be undone or completed" do
          no1.can_undo?.should be_true
          no1.can_complete?.should be_true
        end
        
        it "should validate presence of student" do
          no1.student = nil
          no1.should_not be_valid
        end

        it "should validate presence of lesson" do
          no1.lesson = nil
          no1.should_not be_valid
        end

        it "should delete the lesson if cancelled" do
          lambda do
            no1.cancel
          end.should change(Lesson, :count).by(-1)
        end

        context "and is then undone" do
          before( :each ) do
            no1.undo
          end

          it "should be valid without a student" do
            no1.student = nil
            no1.should be_valid
          end
          
          it "should delete the lesson if the student is cleared" do
            lambda do
              no1.student = nil
              no1.save
            end.should change(Lesson, :count).by(-1)
          end

          it "should delete the lesson if the student is changed" do
            lambda do
              no1.student = FactoryGirl.create(:brother, :congregation => first_school.school_session.congregation)  
              no1.save
            end.should change(Lesson, :count).by(-1)
          end

          it "should be valid without a lesson" do
            no1.lesson = nil
            no1.should be_valid
          end

        end

        context "and a substitute is assigned" do
          before( :each ) do
            no1.substitute = FactoryGirl.create( :brother, :congregation => no1.school_session.congregation )
            no1.completed_by = "substitute"
          end

          it "should be able to be completed" do
            no1.can_complete?.should be_true
          end

          context "and the assignment is completed" do
            before( :each ) do
              no1.complete
            end

            it "should be in the substituted state" do
              no1.should be_substituted
            end

            it "should reset the start date of the old lesson" do
              no1.lesson.reload
              no1.lesson.date_started.should be_nil
            end
          end
        end
      end
    end

    context "and with an old lesson that hasn't been finished" do
      before( :each ) do
        @start_date = no1.school_session.week_of - 7
        no1.student.lessons.create(
                      :date_started  => @start_date,
                      :lesson_source => no1.school_session.congregation.language.lesson_sources.first )
        no1.lesson = no1.student.lessons.pending.first
      end

      it "should be able to be assigned" do
        no1.can_assign?.should be_true
      end

      it "should not changed the start date of the lesson when assigned" do
        no1.assign
        no1.lesson.date_started.should == @start_date
      end
    end
  end
end
