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
  end
end
