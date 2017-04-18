Rails.application.routes.draw do
  root :to => redirect(path: '/links')

  get 'signin' => 'sessions#new'
  post 'signin' => 'sessions#create'
  
  delete 'signout' => 'sessions#destroy'

  get 'signup' => 'users#new'
  post 'signup' => 'users#create'

  resources :links, only: [:index, :create, :update]
  put 'updatelink/:id' => 'links#updatelink'

  namespace :api do
    namespace :v1 do
      resources :links, only: [:index, :create, :update]
    end
  end
end
