namespace :siamis do
  namespace :users do

    desc "Change user password"
    task committee_password: :environment do
      r = Random.new
        (SCIENTIFIC_COMMITTEE + COCHAIRS).each do |mail|
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
end


