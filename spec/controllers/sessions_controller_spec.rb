require 'spec_helper'

RSpec.describe SessionsController, :type => :controller do
  let(:user){ FactoryGirl.create(:user, password: 'secret', password_confirmation: 'secret')}

  describe "for loggedin users" do
    before {sign_in user, no_capybara: true}

    it "should redirect to user show page" do
      get :new
      expect(response).to redirect_to root_path
    end
  end

  describe "for non-loggedin users" do
    it "should get new" do
      get :new
      expect(response).to be_success
    end
  end
end