require "spec_helper"

describe StudentsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/congregations/1/students" }.should route_to(:controller => "students", :congregation_id => "1", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/congregations/1/students/new" }.should route_to(:controller => "students", :congregation_id => "1", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/congregations/1/students/1" }.should route_to(:controller => "students", :action => "show", :congregation_id => "1", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/congregations/1/students/1/edit" }.should route_to(:controller => "students", :action => "edit", :congregation_id => "1", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/congregations/1/students" }.should route_to(:controller => "students", :congregation_id => "1", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/congregations/1/students/1" }.should route_to(:controller => "students", :action => "update", :congregation_id => "1", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/congregations/1/students/1" }.should route_to(:controller => "students", :action => "destroy", :congregation_id => "1", :id => "1")
    end
  end
end
