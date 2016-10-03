Rails.application.routes.draw do

  resources :topics do
    resources :posts, except: [:index]
  end

# create routes for #new and #create actions
# [only:] prevents Rails creating unnecessary routes
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]


  get 'about' => 'welcome#about'

  root 'welcome#index'
end
