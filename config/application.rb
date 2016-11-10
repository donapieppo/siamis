require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
MASTERS_OF_UNIVERSE  = ['pietro.donatini@unibo.it', 'valeria.montesi3@unibo.it', 'm.ghedini@unibo.it']
COCHAIRS             = ['fiorella.sgallari@unibo.it', 
                        'omar@ices.utexas.edu']
SCIENTIFIC_COMMITTEE = ['marcelo.bertalmio@upf.edu',
                        'jmchung@vt.edu',
                        'pcha@dtu.dk',
                        'j.kaipio@auckland.ac.nz',
                        'eric.miller@tufts.edu',
                        'nikolova@cmla.ens-cachan.fr',
                        'ronny.ramlau@ricam.oeaw.ac.at',
                        'cbs31@cam.ac.uk',
                        'steidl@mathematik.uni-kl.de',
                        'tai@mi.uib.no',
                        'waller@berkeley.edu',
                        'brendt@lanl.gov']
ORGANIZER_COMMITTEE  = ['m.ghedini@unibo.it']

module Siamis
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Rome'
    config.i18n.default_locale = :en
    config.active_record.time_zone_aware_types = [:datetime, :time]

    config.impersonate_admins = ['pietro.donatini@unibo.it']

    routes.default_url_options[:host]     = 'tester.dm.unibo.it'
    routes.default_url_options[:protocol] = 'https'

    config.pre_registration_date = Date.parse('12/03/2018')
    config.start_date = Date.parse('05/06/2018')
    config.number_of_days = 3
    config.message_footer = "Siam-is18 June 5-8, 2018 Bologna - Italy"
  end
end
