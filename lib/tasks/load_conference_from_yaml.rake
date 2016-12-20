require 'yaml' 

namespace :siamis do
  namespace :load do

    desc "Load from 2016"
    task load_2016: :environment do
      user_id = 1
      YAML.load_file('doc/siam16.yaml').each do |session|
        if session[:type] == 'Minisymposium'

          minisymposium = Minisymposium.create!(name:        session[:name],
                                                number:      session[:number],
                                                description: session[:abstract])
          session[:organizers].each do |user|
            name, surname = user.split(' ', 2)
            db_user = User.where(name: name, surname: surname).first || User.find(user_id += 1)
            minisymposium.organizers.create!(user: db_user)
          end

          session[:presentations].each do |presentation|
            # Optional arguments: word_count=4, supplemental=false, random_words_to_add=6
            presentation = Presentation.create!(name: presentation, abstract: Faker::Hipster.sentence(30, false, 20))
            db_user = User.find(user_id += 1)
            presentation.authors.create!(user: db_user)
            minisymposium.presentations << presentation
          end
        elsif session[:type] == 'ContributedSession'

          cs = ContributedSession.create!(name: session[:name],
                                          number:      session[:number],
                                          description: session[:abstract])
          cs.organizers.create!(user: User.find(user_id += 1))

          session[:presentations].each do |presentation|
            # Optional arguments: word_count=4, supplemental=false, random_words_to_add=6
            presentation = Presentation.create!(name: presentation, abstract: Faker::Hipster.sentence(30, false, 20))
            db_user = User.find(user_id += 1)
            presentation.authors.create!(user: db_user)
            cs.presentations << presentation
          end

          p cs
        end
      end
    end

  end
end

