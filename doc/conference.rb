require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

MASTERS_OF_UNIVERSE  = ['name.surname@example.com', 
                        'name.surname2@example.com']
COCHAIRS             = ['name.surname3@example.com',
                        'name.surname4@example.com']
SCIENTIFIC_COMMITTEE = ['name.surname5@example.com',
                        'name.surname6@example.com']
ORGANIZER_COMMITTEE  = ['name.surname7@unibo.it']

module Siamis
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Rome'
    config.i18n.default_locale = :en
    config.active_record.time_zone_aware_types = [:datetime, :time]

    config.impersonate_admins = ['name.surname@example.com']

    routes.default_url_options[:host]     = 'tester.example.com'
    routes.default_url_options[:protocol] = 'https'

    # general dates
    config.conference_start_date = Date.parse('05/06/2018')
    config.number_of_days = 3

    # Deadlines
    config.deadlines = { pre_registration:       '12/03/2018', # after prices are higher
                         minisymposium_proposal: ['15/07/2017', '18/09/2017'],
                         minisymposium_abstract: ['25/09/2017', '25/10/2017'],
                         presentation_proposal:  ['15/07/2017', '18/10/2017'] }

    config.message_footer = "Conference name June 5-8, 2018 Example - Italy"
  end
end