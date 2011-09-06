require 'spec_helper'

describe StudentsController do

  before(:each) do
    @user = @user ||= FactoryGirl.create( :member )
    sign_in @user
    @controller.stub(:current_user) { @user }
    session[:congregation_id] = "1"
    @congregation ||= mock_model(Congregation).as_null_object
    @user.stub_chain( :congregations, :find ).with( "1" ) { @congregation }
  end

  def mock_student(stubs={})
    (@mock_student ||= mock_model(Student).as_null_object).tap do |student|
      student.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all students as @students" do
      @congregation.stub_chain( :students, :all ) { [mock_student] }
      get :index, :congregation_id => "1"
      assigns(:students).should eq([mock_student])
    end
  end

  describe "GET show" do
    it "assigns the requested student as @student" do
      Student.stub(:find).with("37") { mock_student }
      get :show, :congregation_id => "1", :id => "37"
      assigns(:student).should be(mock_student)
    end
  end

  describe "get new" do
    it "assigns a new student as @student" do
      Brother.stub( :new ) { mock_student }
      get :new, :congregation_id => "1", :type => "Brother"
      assigns( :student ).should be( mock_student )
    end
  end

  describe "GET edit" do
    it "assigns the requested student as @student" do
      @congregation.stub_chain( :students, :find ).with( "37" ).and_return( mock_student )
      get :edit, :congregation_id => "1", :id => "37"
      assigns(:student).should be(mock_student)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created student as @student" do
        Brother.stub(:new).with({'these' => 'params'}) { mock_student(:save => true) }
        post :create, :congregation_id => "1", :brother => {'these' => 'params'}
        assigns(:student).should be(mock_student)
      end

      it "redirects to the created student" do
        Brother.stub(:new).with({'these' => 'params'}) { mock_student(:save => true) }
        post :create, :congregation_id => "1", :brother => {'these' => 'params'}
        response.should redirect_to( congregation_student_url( @congregation.id, mock_student ) )
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved student as @student" do
        Brother.stub(:new).with({'these' => 'params'}) { mock_student(:save => false) }
        post :create, :congregation_id => "1", :brother => {'these' => 'params'}
        assigns(:student).should be(mock_student)
      end

      it "redirects to the 'new' action" do
        Brother.stub(:new).with({'these' => 'params'}) { mock_student(:save => false) }
        post :create, :congregation_id => "1", :brother => {'these' => 'params'}
        response.should redirect_to( :action => 'new' )
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested student" do
        @congregation.stub_chain( :students, :find ).with( "37" ).and_return( mock_student )
        mock_student.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :congregation_id => "1", :id => "37", :student => {'these' => 'params'}
      end

      it "assigns the requested student as @student" do
        @congregation.stub_chain( :students, :find ).with( "1" ).and_return( mock_student(:update_attributes => true) )
        put :update, :congregation_id => "1", :id => "1"
        assigns(:student).should be(mock_student)
      end

      it "redirects to the student" do
        @congregation.stub_chain( :students, :find ).with( "1" ).and_return( mock_student(:update_attributes => true) )
        put :update, :congregation_id => "1", :id => "1"
        response.should redirect_to( congregation_student_url( @congregation.id, mock_student ) )
      end
    end

    describe "with invalid params" do
      it "assigns the student as @student" do
        @congregation.stub_chain( :students, :find ).with( "1" ).and_return( mock_student(:update_attributes => false) )
        put :update, :congregation_id => "1", :id => "1"
        assigns(:student).should be(mock_student)
      end

      it "re-renders the 'edit' template" do
        @congregation.stub_chain( :students, :find ).with( "1" ).and_return( mock_student(:update_attributes => false) )
        put :update, :congregation_id => "1", :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested student" do
      @congregation.stub_chain( :students, :find ).with( "37" ).and_return( mock_student )
      mock_student.should_receive(:destroy)
      delete :destroy, :congregation_id => "1", :id => "37"
    end

    it "redirects to the students list" do
      @congregation.stub_chain( :students, :find ).with( "37" ).and_return( mock_student )
      delete :destroy, :congregation_id => "1", :id => "37"
      response.should redirect_to( congregation_students_path( @congregation.id ) )
    end
  end
end
