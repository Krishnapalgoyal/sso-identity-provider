Rails.application.routes.draw do
  namespace :admin do
    get 'dashboard/index'
  end
  get 'home/index'
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get  'saml/metadata', to: 'saml#metadata'
  post 'saml/auth',     to: 'saml#auth'
  post 'saml/acs',      to: 'saml#acs'
  post 'saml/slo',      to: 'saml#slo'
  get  'saml/slo',      to: 'saml#slo'

  namespace :admin do
    root 'dashboard#index'
    
    resources :service_providers do
      member do
        patch :toggle_status
      end
    end
    
    resources :users
    
    resources :audit_logs, only: [:index, :show] do
      collection do
        get :export
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :service_providers
      resources :users
      
      # API info endpoint
      get 'info', to: 'info#show'
    end
  end

  root to: "home#index"
end
