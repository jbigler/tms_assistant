require "spec_helper"

describe SchedulesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/languages/1/schedules" }.should route_to(:controller => "schedules", :language_id => "1", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/languages/1/schedules/new" }.should route_to(:controller => "schedules", :language_id => "1", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/languages/1/schedules/1" }.should route_to(:controller => "schedules", :language_id => "1", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/languages/1/schedules/1/edit" }.should route_to(:controller => "schedules", :language_id => "1", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/languages/1/schedules" }.should route_to(:controller => "schedules", :language_id => "1", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/languages/1/schedules/1" }.should route_to(:controller => "schedules", :language_id => "1", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/languages/1/schedules/1" }.should route_to(:controller => "schedules", :language_id => "1", :action => "destroy", :id => "1")
    end

  end
end
