require 'rails_helper'
include RandomData

RSpec.describe User, type: :model do

    let(:user) { create(:user) }

    it { is_expected.to have_many(:posts) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:votes) }
    it { is_expected.to have_many(:favorites) }

    # Shoulda (expected) tests for name
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(1) }
    it { is_expected.to allow_value("BloccitUser").for(:name) }

    # Shoulda tests for email
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_length_of(:email).is_at_least(3) }
    it { is_expected.to allow_value("user@bloccit.com").for(:email) }

    # Shoulda tests for password
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to have_secure_password }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }

    describe "attributes" do
      it "responds to name and email address" do
        expect(user).to have_attributes(name: user.name, email: user.email)
      end

      it "responds to role" do
        expect(user).to respond_to(:role)
      end

      it "responds to admin?" do
        expect(user).to respond_to(:admin?)
      end

      it "responds to member?" do
        expect(user).to respond_to(:member?)
      end
    end

    describe "roles" do
      # User.create! defaults .role to :member
      it "is member by default" do
        expect(user.role).to eql("member")
      end

      context "member user" do
        it "returns true for #member?" do
          expect(user.member?).to be_truthy
        end

        it "returns false for #admin?" do
          expect(user.admin?).to be_falsey
        end
      end

      context "admin user" do
        before do
          # Set user.role to :admin
          user.admin!
        end

        it "returns false for #member?" do
          expect(user.member?).to be_falsey
        end

        it "returns true for #admin?" do
          expect(user.admin?).to be_truthy
        end
      end
    end

    describe "invalid user" do
      let(:user_with_invalid_name) { build(:user, name: "") }
      let(:user_with_invalid_email) { build(:user, email: "") }

      it "is an invalid user due to blank name" do
        expect(user_with_invalid_name).to_not be_valid
      end

      it "is an invalid user due to blank email" do
        expect(user_with_invalid_email).to_not be_valid
      end
    end

    describe "#favorite_for(post)" do
      before do
        topic =Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph)
        @post = topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user)
      end

      it "returns `nil` if the user has not favorited the post" do
        # expect - favorite_for will return `nil` if user has not favorited post
        expect(user.favorite_for(@post)).to be_nil
      end

      it "returns the appropriate favorite if it exists" do
        # create - favorite for `user` and @post
        favorite = user.favorites.where(post: @post).create
        # expect - `favorite_for` will return favorite that was just created above
        expect(user.favorite_for(@post)).to eq(favorite)
      end
    end

    describe ".avatar_url" do
      # build - a user with FactoryGirl, passing known email address instead of default; 'build' overrides default email (generated in process so success is already a given) to test against specific strings within familiar user environment
      let(:known_user) { create(:user, email: "blochead@bloc.io") }

      it "returns the proper Gravatar url for a known email entity" do
        # expect - set string that Gravatar should return for email
        # s=48 query parameter specifies returned image should be 48x48 pixels
        expected_gravatar = "http://gravatar.com/avatar/bb6d1172212c180cfbdb7039129d7b03.png?s=48"
        # expect - 'known...tar_url' to return respective '...png?s=48' image
        expect(known_user.avatar_url(48)).to eq(expected_gravatar)
      end
    end
end
