Paapi.configure do |config|
  config.access_key = ENV["AMAZON_ACCESS_KEY"] || Rails.application.credentials.amazon[:access_key]
  config.secret_key = ENV["AMAZON_SECRET_KEY"] || Rails.application.credentials.amazon[:secret_key]
  config.partner_tag = ENV["AMAZON_PARTNER_TAG"] || Rails.application.credentials.amazon[:partner_tag]
end
