require 'spec_helper'

describe SettingSourcesController do

  def mock_setting_source(stubs={})
    (@mock_setting_source ||= mock_model(SettingSource).as_null_object).tap do |setting_source|
      setting_source.stub(stubs) unless stubs.empty?
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
    it "assigns all setting_sources as @setting_sources" do
      @language.stub_chain( :setting_sources, :order ) { [mock_setting_source] }
      get :index, :language_id => "1"
      assigns(:setting_sources).should eq([mock_setting_source])
    end
  end

  describe "GET show" do
    it "assigns the requested setting_source as @setting_source" do
      @language.stub_chain( :setting_sources, :find ).with( "37" ) { mock_setting_source }
      get :show, :language_id => "1", :id => "37"
      assigns(:setting_source).should be(mock_setting_source)
    end
  end

  describe "GET edit" do
    it "assigns the requested setting_source as @setting_source" do
      @language.stub_chain( :setting_sources, :find ).with( "37" ) { mock_setting_source }
      get :edit, :language_id => "1", :id => "37"
      assigns(:setting_source).should be(mock_setting_source)
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested setting_source" do
        @language.stub_chain( :setting_sources, :find ).with( "37" ) { mock_setting_source }
        mock_setting_source.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :language_id => "1", :id => "37", :setting_source => {'these' => 'params'}
      end

      it "assigns the requested setting_source as @setting_source" do
        @language.stub_chain( :setting_sources, :find ).with( "37" ) { mock_setting_source(:update_attributes => true) }
        put :update, :language_id => "1", :id => "37"
        assigns(:setting_source).should be(mock_setting_source)
      end

      it "redirects to the setting_source" do
        @language.stub_chain( :setting_sources, :find ).with( "37" ) { mock_setting_source(:update_attributes => true) }
        put :update, :language_id => "1", :id => "37"
        response.should redirect_to( language_setting_source_url( @language, mock_setting_source ) )
      end
    end

    describe "with invalid params" do
      it "assigns the setting_source as @setting_source" do
        @language.stub_chain( :setting_sources, :find ).with( "37" ) { mock_setting_source( :update_attributes => false ) }
        put :update, :language_id => "1", :id => "37"
        assigns(:setting_source).should be(mock_setting_source)
      end

      it "re-renders the 'edit' template" do
        @language.stub_chain( :setting_sources, :find ).with( "37" ) { mock_setting_source( :update_attributes => false ) }
        put :update, :language_id => "1", :id => "37"
        response.should render_template("edit")
      end
    end
  end
end
