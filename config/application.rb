require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

MASTERS_OF_UNIVERSE = ['pietro.donatini@unibo.it']
ORGANIZER_COMMITTEE = ['fiorella.sgallari@unibo.it', 'serena.morigi@unibo.it']

module Siamis
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Rome'
    config.i18n.default_locale = :en
    config.active_record.time_zone_aware_types = [:datetime, :time]

    config.impersonate_admins = ['pietro.donatini@unibo.it']

    routes.default_url_options[:host]     = 'localhost:3000'
    routes.default_url_options[:protocol] = 'http'

    config.pre_registration_date = Date.parse('12/03/2018')
    config.start_date = Date.parse('05/08/2018')
    config.number_of_days = 3
    config.message_footer = "Siam-is18 test application"
  end
end
