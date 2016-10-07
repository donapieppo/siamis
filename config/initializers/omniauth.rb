Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['SIAMIS_GOOGLE_APP_ID'], ENV['SIAMIS_GOOGLE_APP_SECRET'] 
  provider :facebook, ENV['SIAMIS_FACEBOOK_KEY'], ENV['SIAMIS_FACEBOOK_SECRET']
  provider :developer
end
