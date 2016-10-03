Rails.application.routes.draw do


  resources :users, only: [:new, :create]
  post 'confirm' => 'users#confirm'
  get 'confirm' => 'users#new'
  
  resources :topics do
    resources :posts, except: [:index]
  end


  get 'about' => 'welcome#about'

  root 'welcome#index'
end
