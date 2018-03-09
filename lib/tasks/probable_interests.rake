namespace :siamis do
  namespace :users do

    desc "Create probable interest for speakers/organizers"
    task create_probable_intersts: :environment do
      # interests = Array di { conference_session_id, part }
      # si creano alla fine per avere uniq
      interests = Hash.new {|h,k| h[k]=[] }
      # autori
      Author.speaker.includes(:presentation).each do |a|
        if a.presentation.conference_session_id
          interests[a.user_id] << { conference_session_id: a.presentation.conference_session_id, part: a.presentation.part }
        end
      end
      # organizzatori
      Organizer.includes(:conference_session).each do |o|
       (1..o.conference_session.parts).each do |part|
          interests[o.user_id] << { conference_session_id: o.conference_session_id, part: part }
        end
      end

      interests.each do |user_id, conference_session_hashes|
        # conference_session_hashes = [{:conference_session_id=>17, :part=>1}, {:conference_session_id=>99, :part=>2}]
        conference_session_hashes.uniq.each do |conference_session_hash| 
          Interest.create!(user_id: user_id, conference_session_id: conference_session_hash[:conference_session_id], part: conference_session_hash[:part] )
        end
      end
    end
  end
end




