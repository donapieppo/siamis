require 'csv'

MASTERS_OF_UNIVERSE  = ['name.surname@example.com', 
                        'name.surname2@example.com']
COCHAIRS             = ['name.surname3@example.com',
                        'name.surname4@example.com']
SCIENTIFIC_COMMITTEE = ['name.surname5@example.com',
                        'name.surname6@example.com']
ORGANIZER_COMMITTEE  = ['name.surname7@unibo.it']
MANAGEMENT_COMMETTE  = ['name.surname8@unibo.it']
LOCAL_COMMITTEE      = ['name.surname9@unibo.it']

module Siamis
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Rome'
    config.i18n.default_locale = :en
    config.active_record.time_zone_aware_types = [:datetime, :time]

    config.autoload_paths += %W(#{Rails.root}/app/pdfs)

    config.impersonate_admins = ['name.surname@example.com']
    config.main_impersonations = ['name.surname9@unibo.it', 'name.surname11@unibo.it']

    config.action_mailer.asset_host       = 'https://tester.example.com'
    routes.default_url_options[:host]     = 'tester.example.com'
    routes.default_url_options[:protocol] = 'https'

    # general dates
    config.conference_start_date = Date.parse('05/06/2018')
    config.number_of_days = 3

    # Deadlines
    config.deadlines = { pre_registration:         ['25/09/2017', '04/04/2018'], # after prices are higher
                         minisymposium_proposal:   ['03/07/2017', '15/10/2017'], # can connect and create/update minisymposium
                         minisymposium_acceptance: ['15/10/2017', '26/10/2017'], # committee acceptance, no edit/update?
                         minisymposium_abstract:   ['27/10/2017', '15/11/2017'], # authors updates minisymposium presentations
                         presentation_proposal:    ['20/10/2017', '15/11/2017']  # presentations and posters
                        }

    config.new_password_lenght = 6

    config.durations = { Minitutorial:      120,
                         Minisymposium:      30,
                         Plenary:            45,
                         ContributedSession: 20,
                         PosterSession:      50 }

    config.contact_mail_name = 'siam-is@example.it'
    config.contact_mail      = 'siam-is@example.it'
  end
end
