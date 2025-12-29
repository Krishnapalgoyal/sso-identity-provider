Rails.application.routes.draw do
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

  root to: "home#index"
end
