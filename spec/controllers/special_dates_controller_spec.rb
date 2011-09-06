require 'spec_helper'

describe SpecialDatesController do

  def mock_special_date(stubs={})
    (@mock_special_date ||= mock_model(SpecialDate).as_null_object).tap do |special_date|
      special_date.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    @user = @user ||= FactoryGirl.create( :member )
    sign_in @user
    @controller.stub(:current_user) { @user }
    session[:congregation_id] = "1"
    @congregation ||= mock_model(Congregation).as_null_object
    @user.stub_chain( :congregations, :find ).with( "1" ) { @congregation }
  end

  describe "GET index" do
    it "assigns all special_dates as @special_dates" do
      @congregation.stub_chain( :special_dates, :where, :order ) { [mock_special_date] }
      get :index, :congregation_id => @congregation.id.to_s
      assigns(:special_dates).should eq([mock_special_date])
    end
  end

  describe "GET show" do
    it "assigns the requested special_date as @special_date" do
      @congregation.stub_chain( :special_dates, :find ).with( "37" ) { mock_special_date }
      get :show, :congregation_id => @congregation.id.to_s, :id => "37", :calendar_date => "2011-04-04"
      assigns(:special_date).should be(mock_special_date)
    end
  end

  describe "GET new" do
    it "assigns a new special_date as @special_date" do
      @congregation.stub_chain( :special_dates, :where, :first ) { nil }
      SpecialDate.stub(:new) { mock_special_date }
      get :new, :congregation_id => @congregation.id.to_s, :edit_date => "2011-04-04"
      assigns(:special_date).should be(mock_special_date)
    end
  end

  describe "GET edit" do
    it "assigns the requested special_date as @special_date" do
      @congregation.stub_chain( :special_dates, :find ).with( "37" ) { mock_special_date }
      get :edit, :congregation_id => @congregation.id.to_s, :id => "37", :calendar_date => "2011-04-04"
      assigns(:special_date).should be(mock_special_date)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created special_date as @special_date" do
        @congregation.stub_chain( :special_dates, :build ).with( { 'these' => 'params' } ) { mock_special_date( :save => true ) }
        post :create, :congregation_id => @congregation.id.to_s, :special_date => {'these' => 'params'}
        assigns(:special_date).should be( mock_special_date )
      end

      it "redirects to the created special_date" do
        @congregation.stub_chain( :special_dates, :build ) { mock_special_date( :save => true ) }
        post :create, :congregation_id => @congregation.id.to_s, :special_date => {}
        response.should redirect_to( congregation_special_date_path( @congregation.id, mock_special_date ) )
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved special_date as @special_date" do
        @congregation.stub_chain( :special_dates, :build ) { mock_special_date( :save => false ) }
        post :create, :congregation_id => @congregation.id.to_s, :special_date => {'these' => 'params'}
        assigns(:special_date).should be(mock_special_date)
      end

      it "re-renders the 'new' template" do
        @congregation.stub_chain( :special_dates, :build ) { mock_special_date( :save => false ) }
        post :create, :congregation_id => @congregation.id.to_s, :special_date => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested special_date" do
        @congregation.stub_chain( :special_dates, :find ).with( "37" ) { mock_special_date }
        mock_special_date.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :congregation_id => @congregation.id.to_s, :id => "37", :special_date => {'these' => 'params'}, :calendar_date => "2011-04-04"
      end

      it "assigns the requested special_date as @special_date" do
        @congregation.stub_chain( :special_dates, :find ) { mock_special_date( :update_attributes => true ) }
        put :update, :congregation_id => @congregation.id.to_s, :id => "1", :calendar_date => "2011-04-04"
        assigns(:special_date).should be(mock_special_date)
      end

      it "redirects to the special_date" do
        @congregation.stub_chain( :special_dates, :find ) { mock_special_date( :update_attributes => true ) }
        put :update, :congregation_id => @congregation.id.to_s, :id => "1", :calendar_date => "2011-04-04"
        response.should redirect_to( congregation_special_date_path( @congregation.id, mock_special_date ) )
      end
    end

    describe "with invalid params" do
      it "assigns the special_date as @special_date" do
        @congregation.stub_chain( :special_dates, :find ) { mock_special_date( :update_attributes => false ) }
        put :update, :congregation_id => @congregation.id.to_s, :id => "1", :calendar_date => "2011-04-04"
        assigns(:special_date).should be(mock_special_date)
      end

      it "re-renders the 'edit' template" do
        @congregation.stub_chain( :special_dates, :find ) { mock_special_date( :update_attributes => false ) }
        put :update, :congregation_id => @congregation.id.to_s, :id => "1", :calendar_date => "2011-04-04"
        response.should render_template( "edit" )
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested special_date" do
      @congregation.stub_chain( :special_dates, :find ).with( "37" ) { mock_special_date }
      mock_special_date.should_receive( :destroy )
      delete :destroy, :congregation_id => @congregation.id.to_s, :id => "37", :calendar_date => "2011-04-04"
    end

    it "redirects to the special_dates list" do
      @congregation.stub_chain( :special_dates, :find ) { mock_special_date }
      delete :destroy, :congregation_id => @congregation.id.to_s, :id => "1", :calendar_date => "2011-04-04"
      response.should redirect_to( congregation_special_dates_path( @congregation.id ) )
    end
  end
end
