Rails.application.routes.draw do

  resources :topics do
    resources :posts, except: [:index]
  end

  resources :posts, only: [] do
    resources :comments, only: [:create, :destroy]
  end
# create routes for #new and #create actions
# [only:] prevents Rails creating unnecessary routes

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]

  post 'confirm' => 'users#confirm'

  get 'about' => 'welcome#about'

  root to: 'welcome#index'
end
