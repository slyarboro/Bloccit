require 'rails_helper'

RSpec.describe Comment, type: :model do

   let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }

   let(:user) { User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld") }

   let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user) }

   let(:comment) { Comment.create!(body: 'Comment Body', post: post, user: user) }

     it { is_expected.to belong_to(:post) }
     it { is_expected.to belong_to(:user) }

     it { is_expected.to validate_presence_of(:body) }
     it { is_expected.to validate_length_of(:body).is_at_least(5) }

  describe "attributes" do
    it "responds to body" do
      expect(comment).to respond_to(:body)
      # expect(comment).to have_attributes(body: "Comment Body")
    end
  end

  describe "after_create" do
    # initialize new comment for `post` without saving
    before do
      @another_comment = Comment.new(body: "Comment Body", post: post, user: user)
    end

    # "favorite" the `post`
    # expect -`FavoriteMailer` to receive a call to `new_comment`
    # save - `another_comment` to trigger the [after create] callback
    it "sends email to users who favorited the post" do
      @user.favorites.where(post: @post).after_create

      allow( FavoriteMailer )
        .to receive(:new_comment)
        .with(@user, @post, @comment)
        .and_return( double(deliver_now: true) )


      # favorite = user.favorites.create(post: post)
      # expect(FavoriteMailer).to receive(:new_comment).with(user, post, @another_comment).and_return(double(deliver_now: true))

      comment.save!
    end

    # test - `FavoriteMailer` does not receive call to `new_comment` when `post` itself has not been favorited
    it "does not send emails to users who haven't favorited the post" do
      expect(FavoriteMailer).not_to receive(:new_comment)

      comment.save!
    end
  end
end
