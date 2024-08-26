Rails.application.routes.draw do

  # Different pages for the website
  root to: "pages#home"
  get 'regulation' => 'pages#regulation'
  get 'media' => 'pages#media'
  get 'who_are_we' => 'pages#who_are_we'
  get 'practical_info' => 'pages#practical_info'
  get 'contact' => 'pages#contact'
  get 'our_partners' => 'pages#our_partners'
  get 'apply' => 'pages#apply'
  get 'profile' => 'pages#profile'
  get 'contact' => 'pages#contact'

  # Devise authentication routes
  devise_for :users, controllers: { registrations: 'registrations' }

  # User form application routes
  resources :group_forms, only: [:index, :show, :new, :create] do
    collection do
      # get '/group_forms/:id/info', to: 'groups#info'
      get 'info' # This will create a route for group_forms/info
    end
    resources :participants, only: [:create, :destroy]
  end
  resources :individual_forms, only: [:index, :new, :create]

end
