require "spec_helper"

describe SpecialDatesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/congregations/1/special_dates" }.should route_to(:controller => "special_dates", :congregation_id => "1", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/congregations/1/special_dates/new" }.should route_to(:controller => "special_dates", :congregation_id => "1", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/congregations/1/special_dates/1" }.should route_to(:controller => "special_dates", :action => "show", :congregation_id => "1", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/congregations/1/special_dates/1/edit" }.should route_to(:controller => "special_dates", :action => "edit", :congregation_id => "1", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/congregations/1/special_dates" }.should route_to(:controller => "special_dates", :congregation_id => "1", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/congregations/1/special_dates/1" }.should route_to(:controller => "special_dates", :action => "update", :congregation_id => "1", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/congregations/1/special_dates/1" }.should route_to(:controller => "special_dates", :action => "destroy", :congregation_id => "1", :id => "1")
    end
  end
end
