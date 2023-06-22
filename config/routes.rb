Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :users, only: [:index, :show]

  resources :events, only: [:edit, :update, :show, :destroy, :index, :new, :create] do
    member do
      post 'attend'
      delete 'attend' => 'events#attend'
      post 'invite'
      post 'cancel_invitation' => 'events#cancel_invitation'
    end
  end
  
  # Defines the root path route ("/")
  root "events#index"
end
