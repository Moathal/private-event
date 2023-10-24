Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "events#index"
  
  resources :users

  resources :events, only: [:edit, :update, :show, :destroy, :index, :new, :create] do
    member do
      post 'attend'
      delete 'attend' => 'events#attend'
      post 'invite'
      post 'cancel_invitation' => 'events#cancel_invitation'
      post 'accept_invite' => 'events#accept_invite'
      post 'reject_invite' => 'events#reject_invite'
    end
  end
  
end
