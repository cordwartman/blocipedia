Rails.application.routes.draw do

  resources :charges, only: [:new, :create, :destroy]
  
  resources :wikis

  resources :wikis do
    resources :collaborators, only: [:new, :create, :destroy]
  end

  devise_for :users
  
  get 'welcome/index'

  get 'welcome/about'

  root 'welcome#index'
  
end
