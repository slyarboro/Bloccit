Rails.application.routes.draw do

  resources :topics do
    resources :posts, except: [:index]
    resources :comments, only: [:create, :destroy]
  end

  resources :post, only: [] do
    resources :comments, only: [:create, :destroy]
  end

# create routes for #new and #create actions
# [only:] prevents Rails creating unnecessary routes

  resources :users, only: [:new, :create, :show]
  resources :sessions, only: [:new, :create, :destroy]
  resources :labels, only: [:show]

  get 'about' => 'welcome#about'

  root 'welcome#index'
end
