namespace :siamis do
  namespace :notifications do

    desc "Notify unlogged users"
    task notify_unlogged_users: :environment do
      User.where('sign_in_count = 0 and notified_at is null').each do |user|
        presentations = user.speaks_in.accepted.all
        minisymposia  = user.minisymposia.accepted.all
        presentations.size > 0 or next

        puts user.inspect
        puts presentations.inspect
        puts minisymposia.inspect

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

    desc "Ask minisymposium speakers for abstract"
    task "ask_minisymposium_speakers_for_abstract" do
    end
  end
end


