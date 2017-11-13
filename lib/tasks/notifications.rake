namespace :siamis do
  namespace :notifications do

    desc "Notify unlogged users"
    task notify_unlogged_users: :environment do
      User.where('sign_in_count = 0 and notified_at is null').each do |user|
        presentations = user.speaks_in.accepted.all
        minisymposia  = user.minisymposia.accepted.all
        presentations.size > 0 or next

        p user
        p presentations
        p minisymposia

        STDIN.gets

        password = user.set_random_password
        puts "password: #{password}"

        if password and NotificationMailer.notify_user(user, password, presentations, minisymposia).deliver
          user.update_attribute(:notified_at, Time.now)
        else 
          raise "Error in #{user.inspect}"
        end
      end
    end

    desc "Remind speakers for abstract"
    task remind_abstract: :environment do
      Presentation.where("abstract is null or abstract REGEXP '^[[:space:]]*$'").each do |presentation|
        conference_session = presentation.conference_session

        conference_session.is_a?(Plenary) and next
        conference_session.is_a?(Minitutorial) and next

        user = presentation.speaker.user

        p user
        p presentation
        p conference_session

        STDIN.gets

        NotificationMailer.remind_abstract(user, presentation, conference_session).deliver
      end
    end

  end
end


