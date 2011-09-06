require 'spec_helper'

describe Admin::LanguagesController do

  def mock_language(stubs={})
    (@mock_language ||= mock_model(Language).as_null_object).tap do |language|
      language.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    @user = @user ||=FactoryGirl.create(:admin)
    sign_in @user
  end

  describe "GET index" do
    it "assigns all languages as @languages" do
      Language.stub(:all) { [mock_language] }
      get :index
    end

    describe "GET show" do
      it "assigns the requested language as @language" do
        Language.stub(:find).with("37") { mock_language }
        get :show, :id => "37"
        assigns(:language).should be(mock_language)
      end
    end

    describe "GET new" do
      it "assigns a new language as @language" do
        Language.stub(:new) { mock_language }
        get :new
        assigns(:language).should be(mock_language)
      end
    end

    describe "GET edit" do
      it "assigns the requested language as @language" do
        Language.stub(:find).with("37") { mock_language }
        get :edit, :id => "37"
        assigns(:language).should be(mock_language)
      end
    end

    describe "POST create" do

      describe "with valid params" do
        it "assigns a newly created language as @language" do
          #Why does it require a second hash?
          Language.stub(:new).with( {'language' => '1'}, {} ) { mock_language(:save => true) }
          post :create, :language => {'language' => '1'}
          assigns(:language).should be(mock_language)
        end

        it "redirects to the created language" do
          Language.stub(:new) { mock_language(:save => true) }
          post :create, :language => {'language' => '1'}
          response.should redirect_to(admin_language_url @mock_language)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved language as @language" do
          #It needs the second hash here too... only since Rails 3.1 upgrade
          Language.stub(:new).with({'these' => 'params'}, {}) { mock_language(:save => false) }
          post :create, :language => {'these' => 'params'}
          assigns(:language).should be(mock_language)
        end

        it "re-renders the 'new' template" do
          Language.stub(:new) { mock_language(:save => false, 
                                              :errors => { :anything => "any value (even nil)" } ) }

          post :create, :language => {}
          response.should render_template("new")
        end
      end

    end

    describe "PUT update" do

      describe "with valid params" do
        it "updates the requested language" do
          Language.should_receive(:find).with("37") { mock_language }
          mock_language.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :language => {'these' => 'params'}
        end

        it "assigns the requested language as @language" do
          Language.stub(:find) { mock_language(:update_attributes => true) }
          put :update, :id => "1"
          assigns(:language).should be(mock_language)
        end

        it "redirects to the language" do
          Language.stub(:find) { mock_language(:update_attributes => true) }
          put :update, :id => "1"
          response.should redirect_to(admin_language_url(mock_language))
        end
      end

      describe "with invalid params" do
        it "assigns the language as @language" do
          Language.stub(:find) { mock_language(:update_attributes => false) }
          put :update, :id => "1"
          assigns(:language).should be(mock_language)
        end

        it "re-renders the 'edit' template" do
          Language.stub(:find) { mock_language(:update_attributes => false, 
                                               :errors => { :anything => "any value (even nil)" } ) }

          put :update, :id => "1"
          response.should render_template("edit")
        end
      end

    end

    describe "DELETE destroy" do
      it "destroys the requested language" do
        Language.should_receive(:find).with("37") { mock_language }
        mock_language.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the languages list" do
        Language.stub(:find) { mock_language }
        delete :destroy, :id => "1"
        response.should redirect_to(admin_languages_url)
      end
    end
  end
end
