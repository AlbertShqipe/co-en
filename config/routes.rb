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
    resources :participants, only: [:create, :destroy]
  end
  # Info of a specific group form
  get '/group_forms/:id/info', to: 'group_forms#info'

  resources :individual_forms, only: [:index, :new, :create]

end
