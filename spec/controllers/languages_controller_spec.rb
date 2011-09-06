require 'spec_helper'

describe LanguagesController do

  def mock_language(stubs={})
    (@mock_language ||= mock_model(Language).as_null_object).tap do |language|
      language.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    @user = @user ||=FactoryGirl.create(:member)
    sign_in @user
  end

  describe "GET index" do
    it "assigns all languages as @languages" do
      Language.stub(:all) { [mock_language] }
      get :index
      assigns(:languages).should eq([mock_language])
    end
  end

  describe "GET show" do
    it "assigns the requested language as @language" do
      Language.stub(:find).with("37") { mock_language }
      get :show, :id => "37"
      assigns(:language).should be(mock_language)
    end
  end
end
