namespace :siamis do
  namespace :users do

    desc "Move user"
    task move_user: :environment do
      puts "Give uid from: "
      from_id = STDIN.gets.chomp
      from = User.find(from_id)
      p from

      puts "Give uid to: "
      to_id = STDIN.gets.chomp
      to = User.find(to_id)
      p to

      from.roles.each do |role|
        p role
        p role.conference_session
        p role.presentation
        role.update_attribute(:user_id, to.id)
      end
    end
  end
end



