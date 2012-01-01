require 'spec_helper'

describe DashboardController do

  before(:each) do
    @user = @user ||= FactoryGirl.create( :member )
    sign_in @user
    @controller.stub(:current_user) { @user }
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
