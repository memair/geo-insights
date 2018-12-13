include Devise::OmniAuth::UrlHelpers

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :memair, ENV['MEMAIR_CLIENT_ID'], ENV['MEMAIR_CLIENT_SECRET'], scope: 'public location_read insight_write insight_read'
end
