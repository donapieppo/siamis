namespace :siamis do
  namespace :notifications do

    desc "Notify unlogged users"
    task notify_unlogged_users: :environment do
      User.where(sign_in_count: 0).each do |user|
        presentations = user.presentations.accepted.all
        minisymposia  = user.minisymposia.accepted.all
        (presentations.size + minisymposia.size) > 0 or next

        puts user.cn
        puts presentations.inspect
        puts minisymposia.inspect

        password = user.activate_and_set_password

        if password and NotificationMailer.notify_user(user, password, presentations, minisymposia).deliver
          user.update_attribute(:notified_at, Time.now)
          exit 0
        end
      end
    end

    desc "Ask minisymposium speakers for abstract"
    task "ask_minisymposium_speakers_for_abstract" do
    end
  end
end


