require 'spec_helper'

describe SchoolSession do

  before( :all ) do
    @language = FactoryGirl.create( :language )
    @cong = FactoryGirl.create( :congregation, :language => @language )
  end

  after( :all ) do
    @cong.destroy
    @language.destroy
  end

  it { should belong_to( :congregation ) }
  it { should belong_to( :reader ) }
  it { should belong_to( :bible_highlights ) }
  it { should have_many( :schools ) }

  it { should validate_presence_of( :week_of ) }
  it { should validate_presence_of( :congregation_id ) }

  it "should prevent creating a SchoolSession for any day but Monday" do
    new_session = @cong.school_sessions.build( :week_of => Date.civil( 2011, 4, 5 ) )
    new_session.should have(1).error_on( :week_of )
  end

  it "should strip the time from week_of when creating a SchoolSession" do
    new_session = @cong.school_sessions.build( :week_of => DateTime.civil( 2011, 4, 4, 9, 30 ) )
    new_session.should be_valid
    new_session.week_of.should == Date.civil( 2011, 4, 4 )
  end

  describe "A normal SchoolSession" do
    before( :each ) do
      @session = @cong.school_sessions.create( :week_of => Date.civil( 2011, 4, 4 ) )
    end

    it "that is destroyed should destroy all associated Schools and Assignments" do
      bh_id = @session.bible_highlights.id
      school_id = @session.schools[0].id
      no1_id = @session.schools[0].talk_no1.id
      no2_id = @session.schools[0].talk_no2.id
      no3_id = @session.schools[0].talk_no3.id
      @session.destroy
      Assignment.exists?( bh_id ).should be_false
      Assignment.exists?( no1_id ).should be_false
      Assignment.exists?( no2_id ).should be_false
      Assignment.exists?( no3_id ).should be_false
      School.exists?( school_id ).should be_false
    end

    it { should validate_uniqueness_of( :week_of ).scoped_to( :congregation_id ) }

    it "should not be able to change the week_of attribute" do
      @session.week_of = DateTime.civil( 2011, 4, 11 )
      @session.save
      @session.reload
      @session.week_of.should == DateTime.civil( 2011, 4, 4 )
    end

    it "should have a BibleHighlights assignment" do
      @session.bible_highlights.should be
    end

    it "should not have a Reader assignment" do
      @session.reader.should be_nil
    end

    it "have as many Schools as defined in Congregation#number_of_schools" do
      @session.schools.size.should == @cong.number_of_schools
    end

    it "should start out in the unassigned state" do
      @session.should be_unassigned
    end

    context "that is cancelled" do
      before( :each ) do
        @session.cancel
      end

      it "should clear out all assignments" do
        @session.bible_highlights.should be_nil
        @session.schools.should be_empty
      end

      it "should be in the cancelled state" do
        @session.should be_cancelled
      end

      context "and then reactivated" do
        before( :each ) do
          @session.reactivate
        end

        it "should be in the unassigned state" do
          @session.should be_unassigned
        end

        it "should have a BibleHighlights assignment" do
          @session.bible_highlights.should be
          @session.bible_highlights.schedule_item.should be
        end

        it "have as many Schools as defined in Congregation#number_of_schools" do
          @session.schools.size == @cong.number_of_schools
          @session.schools[0].talk_no1.should be
          @session.schools[0].talk_no1.schedule_item.should be
        end
      end
    end

    context "with the Assignments still unassigned" do
      it "should not be able to be assigned" do
        @session.can_assign?.should be_false
      end
    end

    context "with a student for each Assignment" do
      before( :each ) do
        @session.bible_highlights.student = FactoryGirl.create( :elder, :congregation => @cong )
        school = @session.schools.first
        school.talk_no1.student = FactoryGirl.create( :brother, :congregation => @cong )
        school.talk_no1.lesson_chapter = 1
        school.talk_no2.student = FactoryGirl.create( :sister, :congregation => @cong )
        school.talk_no2.lesson_chapter = 1
        school.talk_no2.assistant = FactoryGirl.create( :sister, :congregation => @cong )
        school.talk_no3.student = FactoryGirl.create( :brother, :congregation => @cong )
        school.talk_no3.lesson_chapter = 1
        @session.save
      end

      it "should be able to be assigned" do
        @session.can_assign?.should be_true
      end

      context "and assigned" do
        before( :each ) do
          @session.assign
        end

        it "should be in the assigned state" do
          @session.should be_assigned
        end

        it "should put all Assignments in the assigned state" do
          @session.bible_highlights.should be_assigned
          school = @session.schools[0]
          school.talk_no1.should be_assigned
          school.talk_no2.should be_assigned
          school.talk_no3.should be_assigned
        end

        context "and is then undone" do
          before( :each ) do
            @session.undo
          end
          
          it "should put all the assignments in the unassigned state" do
            @session.bible_highlights.should be_unassigned
            school = @session.schools[0]
            school.talk_no1.should be_unassigned
            school.talk_no2.should be_unassigned
            school.talk_no3.should be_unassigned
          end
        end
      end
    end
  end
end
