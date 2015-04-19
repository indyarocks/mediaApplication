require 'spec_helper'

RSpec.describe UsersController, :type => :controller do
  let(:user){ FactoryGirl.create(:user, password: 'secret', password_confirmation: 'secret')}
  let(:other_user) { FactoryGirl.create(:user, password: 'secret', password_confirmation: 'secret')}

  describe "For non-logged in user" do

    it "should redirect to home" do
      get :show, id: user
      expect(response).to redirect_to root_path
    end

    it "should render new" do
      get :new
      expect(response).to be_success
      expect(response).to render_template('new')
    end

    it "should redirect edit when not logged in" do
      get :edit, id: user
      expect(response).to redirect_to signin_path
    end

    it "should redirect update when not logged in" do
      patch :update, id: user, user: { first_name: user.first_name, email: user.email }
      expect(response).to redirect_to signin_path
    end
  end

  describe 'for logged in users' do

    it "should redirect edit when logged in as wrong user" do
      sign_in other_user, no_capybara: true
      get :edit, id: user
      expect(response).to redirect_to root_path
    end

    it "should redirect update when logged in as wrong user" do
      sign_in other_user, no_capybara: true
      patch :update, id: user, user: { first_name: other_user.first_name}
      expect(response).to redirect_to root_path
    end
  end
end