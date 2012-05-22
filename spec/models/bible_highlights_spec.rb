require 'spec_helper'

describe BibleHighlights do

  before( :all ) do
    # TODO This test has too much baggage!
    @language = FactoryGirl.create( :language )
    @congregation = FactoryGirl.create( :congregation, :language => @language )
    @session = FactoryGirl.create( :normal_school_session, :congregation => @congregation )
    @elder = FactoryGirl.create( :elder, :congregation => @congregation )
    @elder2 = FactoryGirl.create( :elder, :congregation => @congregation )
  end

  after( :all ) do
    @congregation.destroy
    @language.destroy
  end

  let( :bh ) { @session.bible_highlights }

  it { should have_one( :school_session ) }

  it "should begin in the unassigned state" do
    bh.should be_unassigned
  end

  it "should not be able to be assigned" do
    bh.can_assign?.should be_false
  end

  context "with a student assigned" do
    before( :each ) do
      bh.student = @elder
    end

    it "should be able to be assigned" do
      bh.can_assign?.should be_true
    end

    context "that has been assigned" do
      before( :each ) do
        bh.assign
        # TODO I don't really like this method of determining 
        # who it was completed by...
        bh.completed_by = "student"
      end

      it "should be in the assigned state" do
        bh.should be_assigned
      end

      it "should be able to be undone" do
        bh.can_undo?.should be_true
      end

      it "should be able to be completed" do
        bh.can_complete?.should be_true
      end

      context "and then completed" do
        before( :each ) do
          bh.complete
        end

        it "should be in the completed state" do
          bh.should be_completed
        end

        it "should have the undo event available" do
          bh.can_undo?.should be_true
        end

        context "and then undone" do
          before( :each ) do
            bh.undo
          end

          it "should be in the assigned state" do
            bh.should be_assigned
          end

          it "should clear out the completed_by attribute" do
            bh.completed_by.should be_nil
          end

          context "and a substitute is assigned instead" do
            before( :each ) do
              bh.substitute = @elder2
              bh.completed_by = "substitute"
            end

            it "should be able to be completed" do
              bh.can_complete?.should be_true
            end

            context "and then completed" do
              before( :each ) do
                bh.complete
              end

              it "should be in the substituted state" do
                bh.should be_substituted
              end

              it "should have the undo event available" do
                bh.can_undo?.should be_true
              end

              context "and then undone" do
                before( :each ) do
                  bh.undo
                end

                it "should be in the assigned state" do
                  bh.should be_assigned
                end

                it "should clear out the substitute" do
                  bh.substitute.should be_nil
                  bh.completed_by.should be_nil
                end
              end
            end
          end
        end
      end
    end
  end
end
