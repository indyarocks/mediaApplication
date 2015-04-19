require 'spec_helper'

RSpec.describe User, :type => :model do
  before { @user = User.new(first_name: "Chandan", last_name: "Kumar",
                            email: "user@example.com",
                            password: "foobar", password_confirmation: "foobar")}

  subject { @user }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:password_digest)}
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  it { should respond_to(:authenticate)}
  it { should respond_to(:remember_token)}
  it { should respond_to(:medias)}
  it { should respond_to(:feed)}

  it { should be_valid }

  describe "when first name is not present" do
    before { @user.first_name = ""}
    it { should_not be_valid }
  end

  describe "when last name is not present" do
    before { @user.last_name = ""}
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = ""}
    it { should_not be_valid }
  end

  describe "when user name is too long" do
    before { @user.first_name = "a"*51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_email|
        @user.email = valid_email
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before do
      @user = User.new(first_name: "Chandan", last_name: 'Kumar',
                       email: "chandan.jhun@gmail.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match password confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "return the value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email)}

    describe "authenticate for valid password" do
      before { @user.save }
      it { should eq found_user.authenticate(@user.password)}
    end

    describe "not authenticate for invalid password" do
      let(:user_with_invalid_password){ found_user.authenticate("invalid")}

      it { should_not eq user_with_invalid_password}
      specify{ expect(user_with_invalid_password).to be_falsey}
    end
  end

  describe "with a too short password" do
    before { @user.password = @user.password_confirmation = "a"*5 }
    it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) {"fOOoBar@foO.cOOM"}

    it "should downcase and save email address" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "remember token" do
    before { @user.save }
    it {expect(@user.remember_token).not_to be_blank}
  end

  describe "user feed" do
    before {@user.save}

    let!(:older_media){ FactoryGirl.create(:media, user: @user, created_at: 1.day.ago)}
    let!(:newer_media){ FactoryGirl.create(:media, user: @user, created_at: 1.hour.ago)}

    it "should have right medias in latest first order" do
      expect(@user.feed.to_a).to eq [newer_media, older_media]
    end

    it "should have two feed without feed 'keyword'" do
      expect(@user.feed.count).to eq 2
    end

    describe 'feed with keyword' do
      let!(:keyword_media) {FactoryGirl.create(:media, user: @user, description: 'keyword media')}

      it "should have one feed with keyword 'keyword'" do
        expect(@user.feed('keyword').count).to eq 1
      end

      it "should have zero feed with keyword 'xyz'" do
        expect(@user.feed('xyz').count).to eq 0
      end
    end
  end

end