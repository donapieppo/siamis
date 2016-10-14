Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :users 
  resources :speakers 
  resources :minisymposia do
    resources :organizers 
    resources :presentations
    resources :ratings
  end
  resources :presentations do 
    resources :speakers
    resources :ratings
  end

  resources :minitutorials 
  resources :organizers

  get 'login',                       to: 'logins#index',     as: :login
  get 'logins/logout',               to: 'logins#logout',    as: :logout
  get 'auth/google_oauth2',          as: 'google_login'
  get 'auth/google_oauth2/callback', to: 'logins#google_oauth2'
  get 'auth/facebook',               as: 'facebook_login'
  get 'auth/facebook/callback',      to: 'logins#facebook'
  get 'logins/no_access',            to: 'logins#no_access', as: :no_access

  post 'auth/developer/callback',    to: 'logins#developer'

  get '/privacy', to: 'home#privacy', as: :privacy

  get 'who_impersonate',    to: 'impersonations#who_impersonate',    as: :who_impersonate
  get 'impersonate/:id',    to: 'impersonations#impersonate',        as: :impersonate
  get 'stop_impersonating', to: 'impersonations#stop_impersonating', as: :stop_impersonating

end
