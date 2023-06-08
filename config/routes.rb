Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :users, only: [:index, :show]

  resources :events, only: [:edit, :update, :show, :destory, :index, :new, :create] do
    member do
      post 'attend'
    end
  end
  
  # Defines the root path route ("/")
  root "events#index"
end
