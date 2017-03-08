namespace :siamis do
  namespace :users do

    desc "Create user"
    task create: :environment do
      print "Give email: "
      email = STDIN.gets.chomp
      print "Give name: "
      name = STDIN.gets.chomp
      print "Give surname: "
      surname = STDIN.gets.chomp
      
      u = User.new(name: name, surname: surname, email: email, confirmed_at: Time.now) 
      u.save(validate: false)
    end
  end
end

