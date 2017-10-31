namespace :siamis do
  namespace :users do

    desc "Add parts number in Conference Sessions"
    task order_presentations: :environment do
      Minisymposium.all.each do |minisymposium|
        # if presentations 1 or 2 more than multiple of 4 stick in last one
        c = minisymposium.presentations.count

        (c > 5) or next

        # c = 5 => max_parts = 2; c = 3 => max_parts = 1; c = 8 => max_parts = 2 
        max_parts = ((c - 1) / 4) + 1
        # 
        rest = c % 4 
        max_parts -= 1 if (rest == 1)

        total_presentations = presentation_number = session_part = 0 # initialize

        # total_presentations = 1 => session_part = 1
        # total_presentations = 4 => session_part = 1
        minisymposium.presentations.order(:part, :number, :name).each do |presentation|
          presentation_number += 1
          total_presentations += 1
          if (session_part != (session_part = ((total_presentations - 1) / 4) + 1))
            if session_part > max_parts
              session_part = max_parts
            else
              # start again
              presentation_number = 1 
            end
          end
          presentation.update_attribute(:part, session_part)
          presentation.update_attribute(:number, presentation_number)
        end

        minisymposium.update_attribute(:parts, session_part)
      end
    end
  end
end




