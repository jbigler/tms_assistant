require 'spec_helper'

describe LessonSourcesController do

  def mock_lesson_source(stubs={})
    (@mock_lesson_source ||= mock_model(LessonSource).as_null_object).tap do |lesson_source|
      lesson_source.stub(stubs) unless stubs.empty?
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
    it "assigns all lesson_sources as @lesson_sources" do
      @language.stub_chain( :lesson_sources, :order ) { [mock_lesson_source] }
      get :index, :language_id => "1"
      assigns(:lesson_sources).should eq([mock_lesson_source])
    end
  end

  describe "GET show" do
    it "assigns the requested lesson_source as @lesson_source" do
      @language.stub_chain( :lesson_sources, :find ).with( "37" ) { mock_lesson_source }
      get :show, :language_id => "1", :id => "37"
      assigns(:lesson_source).should be(mock_lesson_source)
    end
  end

  describe "GET edit" do
    it "assigns the requested lesson_source as @lesson_source" do
      @language.stub_chain( :lesson_sources, :find ).with( "37" ) { mock_lesson_source }
      get :edit, :language_id => "1", :id => "37"
      assigns(:lesson_source).should be(mock_lesson_source)
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested lesson_source" do
        @language.stub_chain( :lesson_sources, :find ).with( "37" ) { mock_lesson_source }
        mock_lesson_source.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :language_id => "1", :id => "37", :lesson_source => {'these' => 'params'}
      end

      it "assigns the requested lesson_source as @lesson_source" do
        @language.stub_chain( :lesson_sources, :find ).with( "37" ) { mock_lesson_source(:update_attributes => true) }
        put :update, :language_id => "1", :id => "37"
        assigns(:lesson_source).should be(mock_lesson_source)
      end

      it "redirects to the lesson_source" do
        @language.stub_chain( :lesson_sources, :find ).with( "37" ) { mock_lesson_source(:update_attributes => true) }
        put :update, :language_id => "1", :id => "37"
        response.should redirect_to( language_lesson_source_url( @language, mock_lesson_source ) )
      end
    end

    describe "with invalid params" do
      it "assigns the lesson_source as @lesson_source" do
        @language.stub_chain( :lesson_sources, :find ).with( "37" ) { mock_lesson_source( :update_attributes => false ) }
        put :update, :language_id => "1", :id => "37"
        assigns(:lesson_source).should be(mock_lesson_source)
      end

      it "re-renders the 'edit' template" do
        @language.stub_chain( :lesson_sources, :find ).with( "37" ) { mock_lesson_source( :update_attributes => false ) }
        put :update, :language_id => "1", :id => "37"
        response.should render_template("edit")
      end
    end
  end
end
