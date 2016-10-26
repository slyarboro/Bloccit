require 'rails_helper'

RSpec.describe Api::V1::TopicsController, type: :controller do
  # let(:my_user) { create(:user) }
  # let(:my_topic) { create(:topic) }
    let(:my_user) { create(:user) }
    let(:my_topic) { create(:topic) }
    let(:my_post) { create(:post, topic: my_topic, user: my_user) }
    let(:my_comment) { Comment.create!(body: RandomData.random_paragraph, post: my_post, user: my_user) }

  context "unauthenticated user" do
    it "GET index returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "GET show returns http success" do
      get :show, id: my_topic.id
      expect(response).to have_http_status(:success)
    end
  end

  it "GET show returns child posts" do
    get :show, id: my_topic.id
    expect(response.body).to eq(my_topic.to_json)
    # expect(response.content_type).to eq 'application/json'
  end
end

context "unauthorized user" do
  before do
    controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
  end

  # it "GET index returns http success" do
  #   get :index
  #   expect(response).to have_http_status(:success)
  # end

  # it "GET show returns http success" do
  #   get :show, id: my_topic.id
  #   expect(response).to have_http_status(:success)
  # end

  # it "GET show returns child posts" do
  #   get :show, id: my_topic.id
  #   # expect(reponse.content_type).to eq
  #   expect(response.body).to eq(my_user.to_json)

  # end
end
