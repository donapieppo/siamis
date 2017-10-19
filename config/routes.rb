Rails.application.routes.draw do
  # thanx to https://github.com/plataformatec/devise/wiki/How-To:-Use-Recaptcha-with-Devise
  devise_for :users, controllers: { registrations: 'registrations', passwords: 'passwords' }

  root to: 'home#index'

  resources :users do
    post :admin_create, on: :collection # skip devise registration
    post :admin_notify_new, on: :member
    resources :presentations
    get :mailing_list, on: :collection
    get :multiple_speakers, on: :collection
    get :affiliations, on: :collection
    get :missing_affiliation, on: :collection
    put :update_affiliation, on: :member
  end

  resources :authors do
    put :make_speaker, on: :member
  end

  # generic
  resources :conference_sessions do 
    get  :manage_presentations, on: :member
    post :ordering, on: :member
    resources :schedules
    resources :organizers
    resources :interests do
      post :toggle, on: :collection
    end
    resources :presentations do 
      put :add, on: :member
      put :remove, on: :member
    end
  end

  # one presentation session
  resources :minitutorials do
    resources :organizers
    resources :schedules
  end

  # one presentation session
  resources :plenaries do
    resources :organizers
    resources :schedules
  end

  # many presentations
  resources :contributed_sessions do
    resources :organizers
    resources :schedules
    resources :presentations
  end

  # many presentations
  # accept and refuse
  resources :minisymposia do
    resources :organizers 
    resources :presentations
    resources :ratings
    resources :schedules
    put 'accept', on: :member
    put 'refuse', on: :member
  end

  resources :poster_sessions do 
    resources :schedules
    resources :organizers
    get :manage_presentations, on: :member
    post 'ordering', on: :member
    resources :presentations do 
      put 'add', on: :member
      put 'remove', on: :member
    end
  end

  resources :schedules

  resources :presentations do 
    resources :authors
    resources :papers
    resources :ratings
    resources :interests do
      post :toggle, on: :collection
    end
    put 'accept',   on: :member
    put 'refuse',   on: :member
  end

  resources :papers

  resources :payments do
    get :verify, on: :member, as: :verify
    get :error,  on: :member, as: :error
  end

  resources :organizers
  resources :ratings
  resources :buildings
  resources :rooms
  resources :interests

  resources :conference_registrations do 
    get  :check,         on: :collection, as: :check
    get  :print,         on: :member, as: :export

    get  :manual_new,    on: :collection, as: :manual_new
    post :manual_create, on: :collection, as: :manual_create
  end

  resources :tags 
  resources :hotels
  resources :invitation_letters

  get 'submissions',                 to: 'submissions#index', as: :submissions
  get 'submissions/admin',           to: 'submissions#admin', as: :admin_submissions
  get 'logins/no_access',            to: 'logins#no_access',  as: :no_access

  get 'privacy',       to: 'home#privacy',       as: :privacy
  get 'contacts',      to: 'home#contacts',      as: :contacts
  get 'venue',         to: 'home#venue',         as: :venue
  get 'participants',  to: 'home#participants',  as: :participants
  get 'travel_awards', to: 'home#travel_awards', as: :travel_awards
  get 'satellites',    to: 'home#satellites',    as: :satellites
  get 'credits',       to: 'home#credits',       as: :credits

  get 'prize',           to: 'home#prize',       as: :prize
  get 'child_care',      to: 'home#child_care',  as: :child_care
  get 'visa',            to: 'home#visa',        as: :visa
  get 'equipments',      to: 'home#equipments',  as: :equipments

  get 'conference_program' , to: 'conference_program#index', as: :conference_program

  get 'who_impersonate',    to: 'impersonations#who_impersonate',    as: :who_impersonate
  get 'impersonate/:id',    to: 'impersonations#impersonate',        as: :impersonate
  get 'stop_impersonating', to: 'impersonations#stop_impersonating', as: :stop_impersonating

  get 'stats/countries', to: 'stats#countries', as: :countries_stats
end
