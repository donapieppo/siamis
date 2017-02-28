require File.expand_path('../../../doc/new_users.rb', __FILE__)

namespace :siamis do
  namespace :users do

    desc "Create new users"
    task populate: :environment do
      
      NEW_USERS.each do |u|
        user = User.where(email: u[2]).first || User.create(email: u[2], confirmed_at: Time.now, password: Devise.friendly_token.first(Rails.configuration.new_password_lenght))
        p user
        user.update_attributes(name: u[0], 
                               surname: u[1], 
                               affiliation: u[3],
                               web_page: u[4])
      end
    end
  end
end

