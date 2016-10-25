require 'rails_helper'
include SessionsHelper

RSpec.describe VotesController, type: :controller do
  let(:my_topic) { create(:topic) }
  let(:my_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:user_post) { create(:post, topic: my_topic, user: other_user) }
  let(:my_vote) { create(value: 1) }

  # test - must be signed in to vote on posts, otherwise will be directed to sign-in page
  context "guest" do
    describe "POST up_vote" do
      it "redirects the user to the sign in view" do
        post :up_vote, format: :js, post_id: user_post.id
        expect(response).to redirect_to(new_session_path)
      end
    end

    describe "POST down_vote" do
      it "redirects the user to the sign in view" do
        post :down_vote, format: :js, post_id: user_post.id
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  # create (context) to test signed-in users for voting
  context "signed in user" do
    before do
      create_session(my_user)
      request.env["HTTP_REFERER"] = topic_post_path(my_topic, user_post)
    end

    describe "POST up_vote" do
      # expect - first vote made by user creates a new vote that is then added to post
      it "the users first vote increases number of post votes by one" do
        votes = user_post.votes.count
        post :up_vote, format: :js, post_id: user_post.id
        expect(user_post.votes.count).to eq(votes + 1)
      end

      # test - once user has voted once, no additional votes may be cast
      it "the users second vote does not increase the number of votes" do
        post :up_vote, format: :js, post_id: user_post.id
        votes = user_post.votes.count
        post :up_vote, format: :js, post_id: user_post.id
        expect(user_post.votes.count).to eq(votes)
      end

      # expect - upvoting a post will increase its number by one point/vote
      it "increases the sum of post votes by one" do
        points = user_post.points
        post :up_vote, format: :js, post_id: user_post.id
        expect(user_post.points).to eq(points + 1)
      end

      # test - users are redirected back to correct page based on what pageview they voted from  #[posts show]
      it ":back redirects to posts show page" do
        request.env["HTTP_REFERER"] = topic_post_path(my_topic, user_post)
        post :up_vote, format: :js, post_id: user_post.id
        expect(response).to have_http_status(:success)
      end


      # test - users are redirected back to correct page based on what pageview they voted from  #[topics show]
      it ":back redirects to posts topic show" do
        request.env["HTTP_REFERER"] = topic_path(my_topic)
        post :up_vote, format: :js, post_id: user_post.id
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST down_vote" do
      it "the users first vote increases number of post votes by one" do
        votes = user_post.votes.count
        post :down_vote, format: :js, post_id: user_post.id
        expect(user_post.votes.count).to eq(votes + 1)
      end

      it "the users second vote does not increase the number of votes" do
        post :down_vote, format: :js, post_id: user_post.id
        votes = user_post.votes.count
        post :down_vote, format: :js, post_id: user_post.id
        expect(user_post.votes.count).to eq(votes)
      end

      it "decreases the sum of post votes by one" do
        points = user_post.points
        post :down_vote, format: :js, post_id: user_post.id
        expect(user_post.points).to eq(points - 1)
      end

      it ":back redirects to posts show page" do
        request.env["HTTP_REFERER"] = topic_post_path(my_topic, user_post)
        post :down_vote, format: :js, post_id: user_post.id
        expect(response).to have_http_status(:success)
      end

      it ":back redirects to posts topic show" do
        request.env["HTTP_REFERER"] = topic_path(my_topic)
        post :down_vote, format: :js, post_id: user_post.id
        expect(response).to have_http_status(:success)
      end
    end
  end
end
