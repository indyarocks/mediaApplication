require 'spec_helper'

RSpec.describe MediasController, :type => :controller do
  let(:user){ FactoryGirl.create(:user, password: 'secret', password_confirmation: 'secret')}
  let(:other_user) { FactoryGirl.create(:user, password: 'secret', password_confirmation: 'secret')}
  let(:public_media){ FactoryGirl.create(:public_media, user: user)}
  let(:private_media){ FactoryGirl.create(:private_media, user: user)}

  describe "For non-logged in user" do

    it "should not create media" do
      post :create, media: {description: "Description", url: 'http://google.com',
                            user: user, permission: Media::PERMISSION_HASH[:is_public]}
      expect{FactoryGirl.attributes_for(:media) }.to change(Media,:count).by(0)
      expect(response).to redirect_to signin_path
    end

    it "should not destroy media" do
      delete :destroy, id: public_media
      expect{FactoryGirl.attributes_for(:media) }.to change(Media,:count).by(0)
      expect(response).to redirect_to signin_path
    end
  end

  describe 'for logged in users' do
    before { sign_in user, no_capybara: true}

    describe 'correct user' do
      it "should create media with correct user" do
        expect{post :create, media: {description: "Description", url: 'http://google.com',
                                     user: user, permission: Media::PERMISSION_HASH[:is_public]},
                    media: FactoryGirl.attributes_for(:media) }.to change(Media,:count).by(1)
      end

      it "should destroy media" do
        new_media = FactoryGirl.create(:private_media, user: user)
        expect{delete :destroy, id: new_media, media: FactoryGirl.attributes_for(:media) }.to change(Media,:count).by(-1)
      end
    end

    describe 'wrong user' do
      it "should not destroy media" do
        new_media = FactoryGirl.create(:private_media, user: other_user)
        expect{delete :destroy, id: new_media, media: FactoryGirl.attributes_for(:media) }.to change(Media,:count).by(0)
      end
    end
  end
end