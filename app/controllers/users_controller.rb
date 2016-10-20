class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.save
       flash[:notice] = "Welcome to Bloccit #{@user.name}!"
       create_session(@user)
       redirect_to root_path
     else
       flash[:alert] = "There was an error creating your account. Please try again."
       render :new
     end
   end

  def confirm
    @user = User.new
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
  end

  # retrieve user instance in order to set it to instance variable
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.visible_to(current_user)
    @favorites = @user.favorites
  end
end
