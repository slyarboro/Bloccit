require 'rails_helper'
include SessionsHelper
include RandomData

RSpec.describe FavoritesController, type: :controller do
  let(:my_topic) { create(:topic) }
  let(:my_user) { create(:user) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }

    context 'guest user' do
      describe 'POST create' do
        it 'redirects the user to the sign in view' do
          post :create, { post_id: my_post.id }
          # test - guests are being redirected if they attemp to favorite a post
          expect(response).to redirect_to(new_session_path)
        end
      end

      # test - guest user is redirected to sign in before permitted to unfavorite a post
      describe 'DELETE destroy' do
        it 'redirects the user to the sign in view' do
          favorite = my_user.favorites.where(post: my_post).create
          delete :destroy, { post_id: my_post.id, id: favorite.id }
          expect(response).to redirect_to(new_session_path)
        end
      end
    end

    context 'signed in user' do
      before do
        create_session(my_user)
      end

      describe 'POST create' do
        # expect - after user favorites post, redirect back to that post's show view
        it 'redirects to the posts show view' do
          post :create, { post_id: my_post.id }
          expect(response).to redirect_to([my_topic, my_post])
        end

        it 'creates a favorite for the current user and specified post' do
          # expect - no favorites exist for user and post
          expect(my_user.favorites.find_by_post_id(my_post.id)).to be_nil
          post :create, { post_id: my_post.id }
          # expect - after user has favorited a post, they will have favorite associated with that post
          expect(my_user.favorites.find_by_post_id(my_post.id)).not_to be_nil
        end
      end

      # test - when user unfavorites a post, they redirect to post's show view
      describe 'DELETE destroy' do
        it 'redirects to the posts show view' do
          favorite = my_user.favorites.where(post: my_post).create
          delete :destroy, { post_id: my_post.id, id: favorite.id }
          expect(response).to redirect_to([my_topic, my_post])
        end

        it 'destroys the favorite for the current user and post' do
          favorite = my_user.favorites.where(post: my_post).create
          # expect - user and post have associated favorite that can be deleted
          expect( my_user.favorites.find_by_post_id(my_post.id) ).not_to be_nil
          delete :destroy, { post_id: my_post.id, id: favorite.id }
          # expect - associated favorite is `nil`
          expect( my_user.favorites.find_by_post_id(my_post.id) ).to be_nil
        end
      end
    end
end
