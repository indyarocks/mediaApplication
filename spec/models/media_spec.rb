require 'spec_helper'

RSpec.describe Media, :type => :model do
  let(:user){ FactoryGirl.create(:user)}

  before {@media = user.medias.build(description: 'media description',
                                     url: 'http://example.com',
                                     permission: Media::PERMISSION_HASH[:is_public])}

  subject {@media}

  it { should respond_to(:description)}
  it { should respond_to(:url)}
  it { should respond_to(:permission)}
  it { should respond_to(:user_id)}
  it { should respond_to(:user)}
  it {expect(@media.user).to eq user}

  it { should be_valid }

  describe "a media must be associated with a user" do
    before { @media.user_id = nil}
    it { should_not be_valid}
  end

  describe "with blank description" do
    before {@media.description = ''}

    it {expect(@media).to be_invalid}
  end

  describe "with description larger than 255 characters" do
    before {@media.description = 'c'*256}

    it {expect(@media).to be_invalid}
  end

  describe "with invalid url" do
    it 'should be invalid' do
      invalid_urls = %w(www.example.com example.com example ftp://example.com)
      invalid_urls.each do |invalid_url|
        @media.url = invalid_url
        expect(@media).not_to be_valid
      end
    end
  end

  describe "media permission" do
    it 'with invalid permission' do
      [:is_public, :is_private].each do |permission|
        @media.permission = Media::PERMISSION_HASH[permission]
        expect(@media).to be_valid
      end
    end

    it 'with valid permission' do
      @media.permission = nil
      expect(@media).not_to be_valid
    end
  end

  describe "public media" do
    let!(:public_media1){ FactoryGirl.create(:public_media, description: 'public one')}
    let!(:public_media2){ FactoryGirl.create(:public_media, description: 'public two')}
    let!(:private_media1){ FactoryGirl.create(:private_media, description: 'private one')}
    let!(:private_media2){ FactoryGirl.create(:private_media, description: 'private two')}

    it "should have fetch only public media" do
      expect(Media.public_media.count).to eq 2
    end

    it "should fetch right public medias with given keyword" do
      expect(Media.public_media('one').count).to eq 1
    end

    it "should not fetch any public media if no media has description with given keyword" do
      expect(Media.public_media('none').count).to eq 0
    end
  end
end
