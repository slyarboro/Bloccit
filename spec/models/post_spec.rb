require 'rails_helper'

RSpec.describe Post, type: :model do

   let(:name) {RandomData.random_sentence}
   let(:description) {RandomData.random_paragraph}
   let(:title) { RandomData.random_sentence }
   let(:body) { RandomData.random_paragraph }

   let(:topic) { Topic.create!(name: name, description: description) }

   let(:user) { User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld") }

   let(:post) { topic.posts.create!(title: title, body: body, user: user) }


   it { is_expected.to have_many(:labelings) }
   it { is_expected.to have_many(:labels).through(:labelings) }
   it { is_expected.to have_many(:comments) }
   it { is_expected.to have_many(:votes) }

   it {is_expected.to belong_to(:topic)}
   it {is_expected.to belong_to(:user)}

   it { is_expected.to validate_presence_of(:title) }
   it { is_expected.to validate_presence_of(:body) }
   it { is_expected.to validate_presence_of(:topic) }
   it { is_expected.to validate_presence_of(:user) }

   it { is_expected.to validate_length_of(:title).is_at_least(5) }
   it { is_expected.to validate_length_of(:body).is_at_least(20) }

  describe "attributes" do
        # as provided in checkpoint, add 'User' scope to post tests
        # it "has a title, body, and user attribute" do
        #   expect(post).to have_attributes(title: title, body: body, user: user)
        # end

      it "responds to title" do
        expect(post).to respond_to(:title)
      end
      it "responds to body" do
        expect(post).to respond_to(:body)
      end
  end


  describe "voting" do
  # create up_votes(3) and down_votes(2) before each voting spec
    before do
      3.times {post.votes.create!(value: 1)}
      2.times {post.votes.create!(value: -1)}
      @up_votes = post.votes.where(value: 1).count
      @down_votes = post.votes.where(value: -1).count
    end

  describe "#up_votes" do
  # test - up_votes returns the count of 'up votes'
    it "counts the number of votes with value = 1" do
         expect( post.up_votes ).to eq(@up_votes)
       end
     end

  describe "#down_votes" do
  # test - down_votes returns the count of 'down votes'
       it "counts the number of votes with value = -1" do
         expect( post.down_votes ).to eq(@down_votes)
       end
     end

  # test - points returns sum of all votes on post
  describe "#points" do
       it "returns the sum of all down and up votes" do
         expect( post.points ).to eq(@up_votes - @down_votes)
       end
     end

  describe "#update_rank" do
 # expect - post's rank determined by following this calculation
       it "calculates the correct rank" do
         post.update_rank
         expect(post.rank).to eq (post.points + (post.created_at - Time.new(1970,1,1)) / 1.day.seconds)
       end

       it "updates the rank when an up vote is created" do
         old_rank = post.rank
         post.votes.create!(value: 1)
         expect(post.rank).to eq (old_rank + 1)
       end

       it "updates the rank when a down vote is created" do
         old_rank = post.rank
         post.votes.create!(value: -1)
         expect(post.rank).to eq (old_rank - 1)
       end
     end
  end
end
