namespace :siamis do
  namespace :codes do

    desc "Give codes"
    task give_codes: :environment do
      ms = cp = pp = mt = ip = 0
      Schedule.where(part: 1).includes(:conference_session).includes(:room).order(:start).order('rooms.capacity').each do |sched|
        cs = sched.conference_session

        case cs
        when Minisymposium
          cs.number = (ms += 1)
        when Minitutorial
          cs.number = (mt += 1)
        when Plenary
          cs.number = (ip += 1)
        when ContributedSession
          cs.number = (cp += 1)
        #when PosterSession
        #  cs.number = (pp += 1)
        end

        cs.save!
        p cs
      end
    end
  end
end

