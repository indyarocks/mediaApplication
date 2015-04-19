require 'spec_helper'

RSpec.describe HomeController, :type => :controller do
  describe "Get homepage for non-logged in user" do

    describe "should render correctly" do
      before {get :index}

      it "should render index template" do
        expect(response).to be_success
        expect(response).to render_template("index")
      end

      it "should not have any public post" do
        expect(response).not_to have_selector('mediaList')
      end
    end

    describe "with public posts" do
      before do
        FactoryGirl.create(:public_media, description: 'public one', created_at: 1.days.ago)
        FactoryGirl.create(:public_media, description: 'public two', created_at: 1.hours.ago)
        FactoryGirl.create(:private_media, description: 'private one')
        FactoryGirl.create(:private_media, description: 'private two')
        get :index
      end

      after do
        Media.destroy_all
      end

      it "should have public posts" do
        assigns(:public_media).count equal(2)
      end

      it "should have correct public media post with a given keyword" do
        get :index, q: 'one'
        assigns(:public_media).count equal(1)
      end
    end
  end

  describe "Get homepage for logged in user" do
    let(:user){ FactoryGirl.create(:user)}

    before do
      sign_in user, no_capybara: true
      get :index
    end

    it "should redirect to user index page" do
      expect(response).to redirect_to user
    end
  end

  describe "about page" do
    it "should render about page" do
      get :about
      expect(response).to be_success
      expect(response).to render_template("about")
    end
  end

  describe "help page" do
    it "should render help page" do
      get :help
      expect(response).to be_success
      expect(response).to render_template("help")
    end
  end

  describe "contact page" do
    it "should render contact page" do
      get :contact
      expect(response).to be_success
      expect(response).to render_template("contact")
    end
  end
end