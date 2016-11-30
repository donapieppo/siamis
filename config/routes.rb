Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :users do
    resources :presentations
  end
  resources :authors do
    put :make_speaker, on: :member
  end
  resources :minisymposia do
    resources :organizers 
    resources :presentations
    resources :ratings
    resources :schedules
  end
  resources :minitutorials do
    resources :presentations
    resources :chairs
    resources :schedules
  end
  resources :plenaries do
    resources :chairs
    resources :schedules
  end
  resources :contributed_sessions do
    resources :schedules
  end
  resources :poster_sessions do
    resources :schedules
    resources :presentations do 
      put 'add', on: :member
      put 'remove', on: :member
    end
  end
  resources :schedules
  namespace :commettee do
    resources :conference_sessions 
  end
  resources :conference_sessions do 
    get :manage_presentations, on: :member
    resources :schedules
    resources :presentations do 
      put 'add', on: :member
      put 'remove', on: :member
    end
  end
  resources :presentations do 
    resources :authors
    resources :ratings
  end

  resources :payments do
    get :verify, on: :member, as: :verify
    get :error,  on: :member, as: :error
  end

  resources :organizers
  resources :ratings
  resources :rooms

  resources :conference_registrations do 
    get :check, on: :collection, as: :check
  end

  get 'submissions',                 to: 'submissions#index', as: :submissions
  get 'submissions/admin',           to: 'submissions#admin', as: :admin_submissions
  get 'logins/no_access',            to: 'logins#no_access',  as: :no_access

  get 'privacy',  to: 'home#privacy',  as: :privacy
  get 'contacts', to: 'home#contacts', as: :contacts
  get 'bologna',  to: 'home#bologna',  as: :bologna

  get 'who_impersonate',    to: 'impersonations#who_impersonate',    as: :who_impersonate
  get 'impersonate/:id',    to: 'impersonations#impersonate',        as: :impersonate
  get 'stop_impersonating', to: 'impersonations#stop_impersonating', as: :stop_impersonating

end
