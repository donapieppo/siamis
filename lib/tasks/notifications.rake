namespace :siamis do
  namespace :notifications do

    desc "Notify users"
    task notify_users: :environment do
      User.where(sign_in_count: 0).each do |user|
        presentations = user.presentations.accepted.all
        minisymposia  = user.minisymposia.accepted.all
        (presentations.size + minisymposia.size) > 0 or next
        puts "notify #{user}"
        puts presentations.inspect
        puts minisymposia.inspect
        STDIN.gets 
      end
    end
  end
end


