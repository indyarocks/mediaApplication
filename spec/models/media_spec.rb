require 'spec_helper'

RSpec.describe Media, :type => :model do
  let(:user){ FactoryGirl.create(:user)}

  before {@media = user.medias.build(description: 'media description',
                                     url: 'http://example.com',
                                     permission: Media::PERMISSION[:is_public])}

  subject {@media}

  it { should respond_to(:description)}
  it { should respond_to(:url)}
  it { should respond_to(:permission)}
  it { should respond_to(:user_id)}
  it { should respond_to(:user)}
  it {expect(@media.user).to eq user}

  it { should be_valid }

  describe "with blank description" do
    before {@media.description = ''}

    it {expect(@media).to be_invalid}
  end

  describe "with description larger than 255 characters" do
    before {@media.description = 'c'*256}

    it {expect(@media).to be_invalid}
  end
end
