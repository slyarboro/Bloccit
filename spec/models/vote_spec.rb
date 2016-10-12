require 'rails_helper'

RSpec.describe Vote, type: :model do
   let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
   let(:user) { User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld") }
   let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user) }
   let(:vote) { Vote.create!(value: 1, post: post, user: user) }

 # test - votes belong to posts and users
   it { is_expected.to belong_to(:post) }
   it { is_expected.to belong_to(:user) }
 # test - value is present when votes are created
   it { is_expected.to validate_presence_of(:value) }
 # validate - value is either -1(down vote) or 1(up vote)
   it { is_expected.to validate_inclusion_of(:value).in_array([-1, 1]) }


   describe "update_post callback" do
     it "triggers update_post on save" do
  # expect - update_post_rank called on 'vote' after saved
       expect(vote).to receive(:update_post).at_least(:once)
       vote.save!
     end

     it "#update_post calls update_rank on post " do
 # expect - 'vote's post will receive call to update_rank
       expect(post).to receive(:update_rank).at_least(:once)
       vote.save!
     end
   end
 end
