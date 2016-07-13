# frozen_string_literal: true
Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  resource :welcome, only: %i(show)

  resource :template, only: %i(show update)
  resource :me, only: %i(show)

  resources :nippos,
    controller: 'nippos/backs',
    only: %i(create update),
    constraints: SubmitNameConstraint.new(:back)
  resources :nippos,
    controller: 'nippos/previews',
    only: %i(create update),
    constraints: SubmitNameConstraint.new(:preview)
  resources :nippos,
    controller: 'nippos/drafts',
    only: %i(create update),
    constraints: SubmitNameConstraint.new(:draft)

  resources :nippos, only: %i(new create show update)

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  get '/users/sign_out', controller: 'welcomes', action: 'sign_out'
end
