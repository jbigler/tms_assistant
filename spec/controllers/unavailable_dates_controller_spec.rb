require 'spec_helper'

describe UnavailableDatesController do

  def mock_unavailable_date( stubs = {} )
    ( @mock_unavailable_date ||= mock_model( UnavailableDate ).as_null_object ).tap do | ud |
      ud.stub( stubs ) unless stubs.empty?
    end
  end

  before(:each) do
    @user = @user ||= FactoryGirl.create( :member )
    sign_in @user
    @controller.stub( :current_user ) { @user }
    session[:congregation_id] = "1"
    @congregation ||= mock_model( Congregation ).as_null_object
    @user.stub_chain( :congregations, :find ).with( "1" ) { @congregation }
    @brother ||= mock_model( Brother ).as_null_object
    @congregation.stub_chain( :students, :find ).with( "1" ) { @brother }
  end

  describe "GET index" do
    it "assigns all unavailable_dates as @unavailable_dates" do
      @brother.stub_chain( :unavailable_dates, :all ) { [mock_unavailable_date] }
      get :index, :congregation_id => "1", :student_id => "1"
      assigns( :unavailable_dates ).should eq( [mock_unavailable_date] )
    end
  end

  describe "GET show" do
    it "assigns the requested unavailable_date as @unavailable_date" do
      @brother.stub_chain( :unavailable_dates, :find ).with( "37" ) { mock_unavailable_date }
      get :show, :congregation_id => "1", :student_id => "1", :id => "37"
      assigns( :unavailable_date ).should be( mock_unavailable_date )
    end
  end

  describe "GET new" do
    it "assigns a new unavailable_date as @unavailable_date" do
      @brother.stub_chain( :unavailable_dates, :where, :first ) { nil }
      @brother.stub_chain( :unavailable_dates, :build ) { mock_unavailable_date }
      get :new, :congregation_id => "1", :student_id => "1", :edit_date => "2011-04-04"
      assigns( :unavailable_date ).should be( mock_unavailable_date )
    end
  end

  describe "GET edit" do
    it "assigns the requested unavailable_date as @unavailable_date" do
      @brother.stub_chain( :unavailable_dates, :find ).with( "37" ) { mock_unavailable_date }
      get :edit, :congregation_id => "1", :student_id => "1", :id => "37", :calendar_date => "2011-04-04"
      assigns( :unavailable_date ).should be( mock_unavailable_date )
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created unavailable_date as @unavailable_date" do
        @brother.stub_chain( :unavailable_dates, :build ).with( { 'these' => 'params' } ) { mock_unavailable_date( :save => true ) }
        post :create, :congregation_id => "1", :student_id => "1", :unavailable_date => {'these' => 'params'}
        assigns(:unavailable_date).should be( mock_unavailable_date )
      end

      it "redirects to the created unavailable_date" do
        @brother.stub_chain( :unavailable_dates, :build ) { mock_unavailable_date( :save => true ) }
        post :create, :congregation_id => "1", :student_id => "1", :unavailable_date => {}
        response.should redirect_to( congregation_student_unavailable_date_path( @congregation, @brother, mock_unavailable_date ) )
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved unavailable_date as @unavailable_date" do
        @brother.stub_chain( :unavailable_dates, :build ) { mock_unavailable_date( :save => false ) }
        post :create, :congregation_id => "1", :student_id => "1", :unavailable_date => {'these' => 'params'}
        assigns( :unavailable_date ).should be( mock_unavailable_date )
      end

      it "re-renders the 'new' template" do
        @brother.stub_chain( :unavailable_dates, :build ) { mock_unavailable_date( :save => false ) }
        post :create, :congregation_id => "1", :student_id => "1", :unavailable_date => {}
        response.should render_template( "new" )
      end
    end
  end
end
