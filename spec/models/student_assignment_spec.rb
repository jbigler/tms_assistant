require 'spec_helper'

describe StudentAssignment do

  before( :all ) do
    @language = FactoryGirl.create(:language)
    @cong = FactoryGirl.create(:congregation, :language => @language)
  end

  after(:all) do
    @cong.destroy
    @language.destroy
  end

  it { should belong_to(:lesson) }

  describe "A TalkNo1 Assignment" do
    before(:each) do
      @session = @cong.school_sessions.create(:week_of => Date.civil(2011, 4, 4))
      @talk_no1 = @cong.school_sessions.first.schools[0].talk_no1
    end

    it "should start in the unassigned state" do
      @talk_no1.state.should == "unassigned"
    end

    context "that is cancelled" do
      before(:each) do
        @talk_no1.cancel
      end

      it "should be in the cancelled state" do
        @talk_no1.cancelled?.should be_true
      end
    end

    context "with a student and lesson assigned" do
      before(:each) do
        @brother = FactoryGirl.create(:brother, :congregation => @cong)
        @talk_no1.student = @brother
        @talk_no1.lesson_chapter = 1
      end

      it "should be assignable" do
        @talk_no1.can_assign?.should be_true
      end

      context "and is assigned" do
        before(:each) do
          @talk_no1.assign
        end

        it "should be in the assigned state" do
          @talk_no1.should be_assigned
        end

        it "should have a lesson assigned" do
          @talk_no1.lesson.lesson_source.chapter.should == 1
        end

        context "and then cancelled" do
          before(:each) do
            @talk_no1.cancel
          end

          it "should be in the cancelled state" do
            @talk_no1.should be_cancelled
          end

          it "should not have a student assigned" do
            @talk_no1.student.should be_nil
          end

          context "and then undone" do
            before(:each) do
              @talk_no1.undo
            end

            it "should be in the unassigned state" do
              @talk_no1.should be_unassigned
            end
          end
        end

        context "and then undone" do
          before(:each) do
            @talk_no1.undo
          end

          it "should be in the unassigned state" do
            @talk_no1.should be_unassigned
          end
        end

        context "and then completed by student" do
          before(:each) do
            @talk_no1.completed_by = "student"
            @talk_no1.lesson_status = "complete"
            @talk_no1.complete
          end

          it "should be in the completed state" do
            @talk_no1.should be_completed
          end

          context "and then undone" do
            before(:each) do
              @talk_no1.undo
            end

            it "should be in the assigned state" do
              @talk_no1.should be_assigned
            end

            it "should still be assigned to the student" do
              @talk_no1.student.should equal(@brother)
            end
          end
        end

        context "and then completed by substitute" do
          before(:each) do
            @sub = FactoryGirl.create(:brother, :congregation => @cong)
            @talk_no1.completed_by = "substitute"
            @talk_no1.substitute = @sub
            @talk_no1.complete
          end

          it "should be in the substituted state" do
            @talk_no1.should be_substituted
          end

          it "should have both the original student and substitute assigned" do
            @talk_no1.student.should equal(@brother)
            @talk_no1.substitute.should equal(@sub)
          end

          context "and then undone" do
            before(:each) do
              @talk_no1.undo
            end

            it "should be in the assigned state" do
              @talk_no1.should be_assigned
            end

            it "should have the student assigned" do
              @talk_no1.student.should equal(@brother)
            end

            it "should not have a substitute assigned" do
              @talk_no1.substitute.should be_nil
            end
          end
        end
      end
    end
  end
end
