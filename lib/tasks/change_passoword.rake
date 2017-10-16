namespace :siamis do
  namespace :users do

    desc "Change user password"
    task change_password: :environment do
      r = Random.new
      puts "Give email: "
      mail = STDIN.gets.chomp
      user = User.where(email: mail).first
      user or next
      pass = r.rand(100000..900000)
      user.password = pass
      user.password_confirmation = pass
      user.save
      puts mail + ": " + pass.to_s
    end
  end
end


