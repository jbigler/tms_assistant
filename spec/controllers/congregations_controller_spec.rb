require 'spec_helper'

describe CongregationsController do

  def mock_congregation(stubs={})
    (@mock_congregation ||= mock_model(Congregation).as_null_object).tap do |congregation|
      congregation.stub(stubs) unless stubs.empty?
    end
  end
  
  before(:each) do
    @user = @user ||= FactoryGirl.create( :member )
    sign_in @user
    @controller.stub(:current_user) { @user }
  end

  describe "GET index" do
    it "assigns all congregations as @congregations" do
      @user.stub( :congregations ) { [mock_congregation] }
      get :index
      assigns(:congregations).should eq([mock_congregation])
    end
  end

  describe "GET show" do
    it "assigns the requested congregation as @congregation" do
      @user.stub_chain(:congregations, :find).with("37").and_return( mock_congregation )
      get :show, :id => "37"
      assigns(:congregation).should be(mock_congregation)
    end
  end

  describe "GET new" do
    it "assigns a new congregation as @congregation" do
      @user.stub_chain(:congregations, :new).and_return( mock_congregation )
      get :new
      assigns(:congregation).should be(mock_congregation)
    end
  end

  describe "GET edit" do
    it "assigns the requested congregation as @congregation" do
      @user.stub_chain(:congregations, :find).with("37").and_return( mock_congregation )
      get :edit, :id => "37"
      assigns(:congregation).should be(mock_congregation)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created congregation as @congregation" do
        @user.stub( :default_congregation_id ) { 1 }
        @user.stub_chain(:congregations, :build).with('name' => 'test', 'language_id' => '1').and_return( mock_congregation( :save => true ) )
        post :create, :congregation => {'name' => 'test', 'language_id' => '1'}
        assigns( :congregation ).should be( mock_congregation )
      end

      it "redirects to the created congregation" do
        @user.stub( :default_congregation_id ) { 1 }
        @user.stub_chain(:congregations, :build) { mock_congregation( :save => true ) }
        post :create, :congregation => {}
        response.should redirect_to( congregation_url( mock_congregation ) )
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved congregation as @congregation" do
        @user.stub( :default_congregation_id ) { 1 }
        @user.stub_chain(:congregations, :build).with('name' => 'test', 'language_id' => '1').and_return( mock_congregation( :save => false ) )
        post :create, :congregation => {'name' => 'test', 'language_id' => '1'}
        assigns(:congregation).should be(mock_congregation)
      end

      it "re-renders the 'new' template" do
        @user.stub_chain(:congregations, :build).with('name' => 'test', 'language_id' => '1')
                                              .and_return( mock_congregation( :save => false, 
                                                                              :valid? => false,
                                                                              :errors => { :anything => "any value (even nil)" } ) )
        post :create, :congregation => {'name' => 'test', 'language_id' => '1'}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested congregation" do
        @user.stub_chain(:congregations, :find).with("37").and_return( mock_congregation )
        mock_congregation.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :congregation => {'these' => 'params'}
      end

      it "assigns the requested congregation as @congregation" do
        @user.stub_chain(:congregations, :find) { mock_congregation( :update_attributes => true ) }
        put :update, :id => "1"
        assigns(:congregation).should be(mock_congregation)
      end

      it "redirects to the congregation" do
        @user.stub_chain(:congregations, :find) { mock_congregation( :update_attributes => true ) }
        put :update, :id => "1"
        response.should redirect_to(congregation_url(mock_congregation))
      end
    end

    describe "with invalid params" do
      it "assigns the congregation as @congregation" do
        @user.stub_chain(:congregations, :find) { mock_congregation( :update_attributes => false ) }
        put :update, :id => "1"
        assigns(:congregation).should be(mock_congregation)
      end

      it "re-renders the 'edit' template" do
        @user.stub_chain(:congregations, :find) { mock_congregation(:update_attributes => false, 
                                                     :errors => { :anything => "any value (even nil)" } ) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested congregation" do
      @user.stub_chain(:congregations, :find).with("37").and_return( mock_congregation )
      mock_congregation.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the congregations list" do
      @user.stub_chain(:congregations, :find) { mock_congregation }
      delete :destroy, :id => "1"
      response.should redirect_to(congregations_url)
    end
  end

end
