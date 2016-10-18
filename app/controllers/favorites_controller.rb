class FavoritesController < ApplicationController
   # redirect - guest users must sign in before favoriting
   before_action :require_sign_in

   def create
     # find - post to favorite using `post_id` in `params`
     # create - favorite for `current_user`, passing in `post` to establish associations for: user, post & favorite
     post = Post.find(params[:post_id])
     favorite = current_user.favorites.build(post: post)

     if favorite.save
       flash[:notice] = "Post favorited."
     else
       flash[:alert] = "Favoriting failed."
     end

     # redirect - user to post's show view
     redirect_to [post.topic, post]
   end

   # Rails scaffolding, welcome.
   def destroy
     post = Post.find(params[:post_id])
     favorite = current_user.favorites.find(params[:id])

     if favorite.destroy
       flash[:notice] = "Post has been removed."
     else
       flash[:alert] = "Failed to remove favorite. Please try again."
       redirect_to [post.topic, post]
     end
   end
end
