require 'spec_helper'

describe SchedulesController do

  def mock_schedule(stubs={})
    (@mock_schedule ||= mock_model(Schedule).as_null_object).tap do |schedule|
      schedule.stub(stubs) unless stubs.empty?
      schedule.stub( :week_of => Date.civil( 2011, 2, 14 ) )
    end
  end

  before( :each ) do
    @user = @user ||= FactoryGirl.create( :member )
    sign_in @user
    @controller.stub( :current_user ) { @user }
    @language ||= mock_model( Language ).as_null_object
    Language.stub( :find ).with( "1" ) { @language }
  end

  describe "GET index" do
    it "assigns all schedules as @schedules" do
      @language.stub_chain( :schedules, :where, :order ) { [mock_schedule] }
      get :index, :language_id => "1"
      assigns(:schedules).should eq([mock_schedule])
    end
  end

  describe "GET show" do
    it "assigns the requested schedule as @schedule" do
      @language.stub_chain( :schedules, :find ).with( "37" ) { mock_schedule }
      get :show, :language_id => "1", :id => "37", :calendar_date => '2011-02-14'
      assigns(:schedule).should be(mock_schedule)
    end
  end

  describe "GET edit" do
    it "assigns the requested schedule as @schedule" do
      @language.stub_chain( :schedules, :find ).with( "37" ) { mock_schedule }
      get :edit, :language_id => "1", :id => "37"
      assigns(:schedule).should be(mock_schedule)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested schedule" do
        @language.stub_chain( :schedules, :find ).with( "37" ) { mock_schedule }
        mock_schedule.should_receive(:update_attributes).with( {'these' => 'params'} )
        put :update, :language_id => "1", :id => "37", :schedule => {'these' => 'params'}
      end

      it "assigns the requested schedule as @schedule" do
        @language.stub_chain( :schedules, :find ) { mock_schedule(:update_attributes => true) }
        put :update, :language_id => "1", :id => "1"
        assigns( :schedule ).should be( mock_schedule )
      end

      it "redirects to the schedule" do
        @language.stub_chain( :schedules, :find ) { mock_schedule( :update_attributes => true ) }
        put :update, :language_id => "1", :id => "1"
        response.should redirect_to( language_schedule_url( @language, mock_schedule ) )
      end
    end

    describe "with invalid params" do
      it "assigns the schedule as @schedule" do
        @language.stub_chain( :schedules, :find ) { mock_schedule( :update_attributes => false ) }
        put :update, :language_id => "1", :id => "1"
        assigns( :schedule ).should be( mock_schedule )
      end

      it "re-renders the 'edit' template" do
        @language.stub_chain( :schedules, :find ) { mock_schedule( :update_attributes => false ) }
        put :update, :language_id => "1", :id => "1"
        response.should render_template("edit")
      end
    end
  end
end
