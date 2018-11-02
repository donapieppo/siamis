Rails.application.routes.draw do
  # thanx to https://github.com/plataformatec/devise/wiki/How-To:-Use-Recaptcha-with-Devise
  # devise_for :users, controllers: { registrations: 'registrations', passwords: 'passwords' }

  root to: 'home#index'

  resources :users do
    post :admin_create, on: :collection # skip devise registration
    post :admin_notify_new, on: :member
    put :update_affiliation, on: :member
    get :multiple_speakers, on: :collection
    get :affiliations, on: :collection
    get :schedules, on: :collection
    get :missing_affiliation, on: :collection
    get :mailing_list, on: :collection
    get :mailing_lists, on: :collection
    get :stats, on: :collection
    get :dietaries, on: :collection
    get :expected, on: :collection
    get :expected2, on: :collection
    get :final_sum, on: :collection
    get :wifi_accounts, on: :collection
    resources :presentations
    resources :manual_payments
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
    get 'print',  on: :collection
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

  resources :panel_sessions do
    resources :organizers
    resources :schedules
  end

  resources :conference_breaks do
    resources :schedules
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

  resources :manual_payments

  resources :organizers
  resources :ratings
  resources :buildings
  resources :rooms
  resources :interests do 
    get :session_ids, on: :collection
  end

  resources :conference_registrations do 
    get  :check,         on: :collection, as: :check
    get  :recipe,        on: :member

    get  :manual_new,    on: :collection, as: :manual_new
    post :manual_create, on: :collection, as: :manual_create

    get :expected,       on: :collection
    get :finisced,       on: :collection
  end

  resources :tags 
  resources :hotels
  resources :invitation_letters do
    put :mark_as_sent,   on: :member
    put :mark_as_unsent, on: :member
  end

  resources :bookings
  resources :sightseeings do
    resources :bookings
  end

  post 'search',            to: 'search#search',     as: :search   

  get 'submissions',       to: 'submissions#index', as: :submissions
  get 'submissions/admin', to: 'submissions#admin', as: :admin_submissions
  get 'logins/no_access',  to: 'logins#no_access',  as: :no_access

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
  get 'travel',          to: 'home#travel',      as: :travel

  get 'conference_program',                     to: 'conference_program#index', as: :conference_program
  get 'day/(:day)/conference_program',          to: 'conference_program#index', as: :conference_program_day, constraints: { day: /\d/ }
  get 'day/(:day)/personal_conference_program', to: 'conference_program#index', as: :personal_conference_program_day, u: 1, constraints: { day: /\d/ }
  get 'day/(:day)',                             to: 'conference_program#index', as: :boh_day, constraints: { day: /\d/ }
  get 'conference_program/print',               to: 'conference_program#print', as: :print_conference_program

  get 'who_impersonate',    to: 'impersonations#who_impersonate',    as: :who_impersonate
  get 'impersonate/:id',    to: 'impersonations#impersonate',        as: :impersonate
  get 'stop_impersonating', to: 'impersonations#stop_impersonating', as: :stop_impersonating

  get 'stats/countries', to: 'stats#countries', as: :countries_stats

  get 'latex',                  to: 'latex#index',            as: :latex
  get 'latex/plenaries',        to: 'latex#plenaries',        as: :plenaries_latex
  get 'latex/minitutorials',    to: 'latex#minitutorials',    as: :minitutorials_latex
  get 'latex/minisymposia',     to: 'latex#minisymposia',     as: :minisymposia_latex
  get 'latex/contributed',      to: 'latex#contributed',      as: :contributed_latex
  get 'latex/posters',          to: 'latex#posters',          as: :posters_latex
  get 'latex/poster_abstracts', to: 'latex#poster_abstracts', as: :poster_abstracts_latex
  get 'latex/program',          to: 'latex#program',          as: :program_latex
  get 'latex/program_glance',   to: 'latex#program_glance',   as: :program_glance_latex
  get 'latex/speakers_and_organizers', to: 'latex#speakers_and_organizers',       as: :speakers_and_organizers_latex
  get 'latex/doors',            to: 'latex#doors',            as: :doors
  get 'latex/mono_doors',       to: 'latex#mono_doors',       as: :mono_doors
  get 'latex/day',              to: 'latex#day',              as: :latex_day
end
