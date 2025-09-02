Rails.application.routes.draw do
  scope "(:locale)", locale: /en|fr/ do
    # Different pages for the website
    root to: "pages#home"
    get 'regulation' => 'pages#regulation'
    get 'weekend_workshops' => 'pages#weekend_workshops'
    get 'who_we_are' => 'pages#who_we_are'
    get 'practical_info' => 'pages#practical_info'
    get 'contact' => 'pages#contact'
    get 'our_partners' => 'pages#our_partners'
    get 'apply' => 'pages#apply'
    get 'profile' => 'pages#profile'
    get 'admin' => 'pages#admin'
    get "messages" => 'pages#messages'
    get "confirmation_form" => 'pages#confirmation_form'
    get 'test' => 'pages#test'

    #Gallery Controller
    get "galerie",       to: "gallery#index", as: :gallery
    get "galerie/:year", to: "gallery#show",  as: :gallery_year,
                        constraints: { year: /\d{4}/ }

    # Popup
    get 'dismiss_welcome_popup', to: 'pages#dismiss_welcome_popup'

    # Devise authentication routes
    devise_for :users, controllers: { registrations: 'registrations' }

    # User form
    resources :individual_forms, only: [:show, :index, :new, :create, :edit, :update]

    # User form application duo
    resources :duo, only: [:show, :index, :new, :create, :edit, :update] do
      resources :duo_participants, only: [:create, :destroy]
    end

    # User form application trio
    resources :trios, only: [:index, :show, :new, :create, :edit, :update] do
      resources :trio_participants, only: [:create, :destroy]
    end

    # User form application group
    resources :group_forms, only: [:index, :show, :new, :create, :edit, :update] do
      resources :participants, only: [:create, :destroy, :update]
    end

    # Info of a specific solo form
    get '/solos/:id/info', to: 'individual_forms#info'

    # Info of a specific duo form
    get '/duos/:id/info', to: 'duo#info'

    # Info of a specific trio form
    get '/trios/:id/info', to: 'trios#info'

    # Info of a specific group form
    get '/group_forms/:id/info', to: 'group_forms#info'

    # Messages routes
    resources :messages, only: [:index, :new, :create]
  end

end
