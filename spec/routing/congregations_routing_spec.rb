require "spec_helper"

describe CongregationsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/congregations" }.should route_to(:controller => "congregations", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/congregations/new" }.should route_to(:controller => "congregations", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/congregations/1" }.should route_to(:controller => "congregations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/congregations/1/edit" }.should route_to(:controller => "congregations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/congregations" }.should route_to(:controller => "congregations", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/congregations/1" }.should route_to(:controller => "congregations", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/congregations/1" }.should route_to(:controller => "congregations", :action => "destroy", :id => "1")
    end

  end
end
